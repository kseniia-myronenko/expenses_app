RSpec.describe 'Users', type: :request do
  let!(:user) { create(:user, password: Helpers::UserAuthHelper::PASSWORD) }
  let(:page) { Nokogiri::HTML.parse(response.body).text }

  describe 'GET /new' do
    context 'when new user' do
      before { get signup_path }

      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'shows form title' do
        expect(page).to include(I18n.t('authentication.form.title'))
      end
    end

    context 'when already logged in' do
      before do
        authenticate(user)
        get signup_path
      end

      it 'redirects to the main page' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      let(:params) { attributes_for(:user) }

      it 'creates a new User' do
        expect do
          post signup_path, params: { user: params }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the main page' do
        post signup_path, params: { user: params }
        expect(response).to redirect_to(root_path)
      end

      it 'renders success flash' do
        post signup_path, params: { user: params }
        follow_redirect!
        expect(flash[:success]).to be_present
      end

      it 'renders success message' do
        post signup_path, params: { user: params }
        follow_redirect!
        expect(page).to include(I18n.t('authentication.success.sign_up'))
      end
    end

    context 'with empty username' do
      let(:params) { { username: '', password: Helpers::UserAuthHelper::PASSWORD } }

      it 'does not create a new User' do
        expect do
          post signup_path, params: { user: params }
        end.not_to change(User, :count)
      end

      it 'renders sign up page' do
        post signup_path, params: { user: params }
        expect(response).to be_successful
      end

      it 'renders danger flash' do
        post signup_path, params: { user: params }
        expect(flash[:danger]).to be_present
      end

      it 'shows error message' do
        post signup_path, params: { user: params }
        expect(page).to include(I18n.t('activerecord.errors.models.user.attributes.username.blank'))
      end
    end

    context 'with short username' do
      let(:params) { { username: 'An', password: Helpers::UserAuthHelper::PASSWORD } }

      it 'does not create a new User' do
        expect do
          post signup_path, params: { user: params }
        end.not_to change(User, :count)
      end

      it 'renders sign up page' do
        post signup_path, params: { user: params }
        expect(response).to be_successful
      end

      it 'renders danger flash' do
        post signup_path, params: { user: params }
        expect(flash[:danger]).to be_present
      end

      it 'shows error message' do
        post signup_path, params: { user: params }
        expect(page).to include(I18n.t('activerecord.errors.models.user.attributes.username.too_short'))
      end
    end

    context 'with long username' do
      let(:params) { { username: 'An' * User::USERNAME_MAX_LENGTH, password: Helpers::UserAuthHelper::PASSWORD } }

      it 'does not create a new User' do
        expect do
          post signup_path, params: { user: params }
        end.not_to change(User, :count)
      end

      it 'renders sign up page' do
        post signup_path, params: { user: params }
        expect(response).to be_successful
      end

      it 'renders danger flash' do
        post signup_path, params: { user: params }
        expect(flash[:danger]).to be_present
      end

      it 'shows error message' do
        post signup_path, params: { user: params }
        expect(page).to include(I18n.t('activerecord.errors.models.user.attributes.username.too_long'))
      end
    end

    context 'with empty password' do
      let(:params) { { username: 'Bob', password: '' } }

      it 'does not create a new User' do
        expect do
          post signup_path, params: { user: params }
        end.not_to change(User, :count)
      end

      it 'renders sign up page' do
        post signup_path, params: { user: params }
        expect(response).to be_successful
      end

      it 'renders danger flash' do
        post signup_path, params: { user: params }
        expect(flash[:danger]).to be_present
      end

      it 'shows error message' do
        post signup_path, params: { user: params }
        expect(page).to include(I18n.t('activerecord.errors.models.user.attributes.password.blank'))
      end
    end

    context 'with short password' do
      let(:params) { { username: 'Bob', password: '111' } }

      it 'does not create a new User' do
        expect do
          post signup_path, params: { user: params }
        end.not_to change(User, :count)
      end

      it 'renders sign up page' do
        post signup_path, params: { user: params }
        expect(response).to be_successful
      end

      it 'renders danger flash' do
        post signup_path, params: { user: params }
        expect(flash[:danger]).to be_present
      end

      it 'shows error message' do
        post signup_path, params: { user: params }
        expect(page).to include(I18n.t('activerecord.errors.models.user.attributes.password.invalid'))
      end
    end
  end
end
