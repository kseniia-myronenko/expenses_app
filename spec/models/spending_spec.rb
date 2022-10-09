RSpec.describe Spending, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:category) }
  end

  describe 'fields' do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:amount).of_type(:integer) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:category_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:user_id).of_type(:uuid) }
  end

  describe 'validations' do
    subject(:spending) { build(:spending) }

    it { is_expected.to validate_presence_of(:amount) }

    context 'when amount presents' do
      it 'is valid spending' do
        expect(spending).to be_valid
      end

      it 'when successfully saved spending' do
        spending.save
        expect(described_class.count).to eq(1)
      end
    end

    context 'when amount is empty' do
      subject(:spending) { build(:spending, :empty_amount) }

      it 'is invalid spending' do
        expect(spending).not_to be_valid
      end

      it 'does not save spending into database' do
        spending.save
        expect(described_class.count).to eq(0)
      end

      it 'raises an error' do
        expect { spending.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when without user and category' do
      subject(:spending) { build(:spending, :without_user_and_category) }

      it 'is invalid spending' do
        expect(spending).not_to be_valid
      end

      it 'does not save spending into database' do
        spending.save
        expect(described_class.count).to eq(0)
      end

      it 'raises an error' do
        expect { spending.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
