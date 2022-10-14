RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:categories).dependent(:destroy) }
    it { is_expected.to have_many(:spendings).dependent(:destroy) }
  end

  describe 'fields' do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:username).of_type(:string) }
    it { is_expected.to have_db_column(:password_digest).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'validations' do
    subject(:user) { build(:user) }

    it { is_expected.to validate_presence_of(:username) }

    it do
      expect(user).to validate_uniqueness_of(:username)
        .case_insensitive
        .with_message(I18n.t('activerecord.errors.models.user.attributes.username.already_exists'))
    end

    it { is_expected.to validate_presence_of(:password) }

    it do
      expect(user).to validate_length_of(:username)
        .is_at_least(User::USERNAME_MIN_LENGTH).is_at_most(User::USERNAME_MAX_LENGTH)
    end

    it do
      expect(user).to validate_length_of(:password)
        .is_at_least(User::PASSWORD_MIN_LENGTH)
    end

    context 'when valid username presents' do
      it 'is valid user' do
        expect(user).to be_valid
      end

      it 'when successfully saved user' do
        user.save
        expect(described_class.count).to eq(1)
      end
    end

    context 'when username is empty' do
      subject(:user) { build(:user, :with_empty_username) }

      it 'is invalid user' do
        expect(user).not_to be_valid
      end

      it 'does not save user into database' do
        user.save
        expect(described_class.count).to eq(0)
      end

      it 'raises an error' do
        expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when username is too long' do
      subject(:user) { build(:user, username: 'n' * (User::USERNAME_MAX_LENGTH + 1)) }

      it 'is invalid user' do
        expect(user).not_to be_valid
      end

      it 'does not save user into database' do
        user.save
        expect(described_class.count).to eq(0)
      end

      it 'raises an error' do
        expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when username is too short' do
      subject(:user) { build(:user, username: 'na') }

      it 'is invalid user' do
        expect(user).not_to be_valid
      end

      it 'does not save user into database' do
        user.save
        expect(described_class.count).to eq(0)
      end

      it 'raises an error' do
        expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when username is duplicated' do
      subject(:user) { create(:user) }

      let(:duplicated_user) { build(:user, username: user.username) }

      it 'is invalid user' do
        expect(duplicated_user).not_to be_valid
      end

      it 'does not save second user into database' do
        duplicated_user.save
        expect(described_class.count).to eq(1)
      end

      it 'raises an error' do
        expect { duplicated_user.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when password is empty' do
      subject(:user) { build(:user, :with_empty_password) }

      it 'is invalid user' do
        expect(user).not_to be_valid
      end

      it 'does not save user into database' do
        user.save
        expect(described_class.count).to eq(0)
      end

      it 'raises an error' do
        expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
