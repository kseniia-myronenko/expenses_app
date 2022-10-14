RSpec.describe Category, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:spendings).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'fields' do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:heading).of_type(:string) }
    it { is_expected.to have_db_column(:body).of_type(:text) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:user_id).of_type(:uuid) }
  end

  describe 'validations' do
    subject(:category) { build(:category) }

    it { is_expected.to validate_presence_of(:heading) }

    context 'when valid heading presents' do
      it 'is valid category' do
        expect(category).to be_valid
      end

      it 'when successfully saved category' do
        category.save
        expect(described_class.count).to eq(1)
      end
    end

    context 'when heading is empty' do
      subject(:category) { build(:category, :empty_heading) }

      it 'is invalid category' do
        expect(category).not_to be_valid
      end

      it 'does not save category into database' do
        category.save
        expect(described_class.count).to eq(0)
      end

      it 'raises an error' do
        expect { category.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when without user' do
      subject(:category) { build(:category, :without_user) }

      it 'is invalid category' do
        expect(category).not_to be_valid
      end

      it 'does not save category into database' do
        category.save
        expect(described_class.count).to eq(0)
      end

      it 'raises an error' do
        expect { category.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when duplicate category heading' do
      subject(:category) { create(:category) }

      let(:category_with_duplicated_heading) { build(:category, heading: category.heading, user: category.user) }

      it 'is invalid category' do
        expect(category_with_duplicated_heading).not_to be_valid
      end

      it 'does not save second category into database' do
        category_with_duplicated_heading.save
        expect(described_class.count).to eq(1)
      end

      it 'raises an error' do
        expect { category_with_duplicated_heading.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
