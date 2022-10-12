RSpec.describe 'Users', type: :request do
  let!(:user) { create(:user, password: Helpers::UserAuthHelper::PASSWORD) }
  let(:page) { Nokogiri::HTML.parse(response.body).text }

  describe 'GET /show' do
    context 'when get show page of current user' do
      before do
        authenticate(user)
        get user_path(user)
      end

      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'shows the title' do
        expect(page).to include(I18n.t('user.show.title'))
      end
    end

    context 'when get show page of another user' do
      let!(:another_user) { create(:user) }

      before do
        authenticate(user)
        get user_path(another_user)
      end

      it 'does not render show page of another user' do
        expect(response).to redirect_to(user_path(user))
      end
    end
  end

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

  describe 'GET /edit' do
    context 'when current user' do
      before do
        authenticate(user)
        get edit_user_path(user)
      end

      it 'render a successful response' do
        expect(response).to be_successful
      end

      it 'shows edit page title' do
        expect(page).to include(I18n.t('user.edit.title'))
      end
    end

    context 'when get edit page of another user' do
      let!(:another_user) { create(:user) }

      before do
        authenticate(user)
        get edit_user_path(another_user)
      end

      it 'does not render edit page of another user' do
        expect(response).to redirect_to(user_path(user))
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

  describe 'PATCH /update' do
    before { authenticate(user) }

    context 'with valid parameters' do
      let(:params) { { username: 'new_username', password: 'newpassword' } }

      it 'updates the user account' do
        patch user_path(user), params: { user: params }
        user.reload
        expect(user.username).to eq('new_username')
      end

      it 'redirects to the user' do
        patch user_path(user), params: { user: params }
        user.reload
        expect(response).to redirect_to(user_path(user))
      end
    end

    context 'with duplicated username' do
      let(:user_new) { create(:user) }
      let(:params) { { username: user_new.username, password: 'newpassword' } }

      it 'does not update account' do
        patch user_path(user), params: { user: params }
        user.reload
        expect(user.username).not_to eq(user_new.username)
      end

      it 'renders edit page' do
        patch user_path(user), params: { user: params }
        user.reload
        expect(response).to be_successful
      end

      it 'renders danger flash' do
        patch user_path(user), params: { user: params }
        user.reload
        expect(flash[:danger]).to be_present
      end

      it 'shows error message' do
        patch user_path(user), params: { user: params }
        user.reload
        expect(page).to include(I18n.t('activerecord.errors.models.user.attributes.username.already_exists'))
      end
    end

    context 'with invalid params of password and username' do
      let(:params) { { username: 'ab', password: 'newpassword' } }

      it 'does not update account' do
        patch user_path(user), params: { user: params }
        user.reload
        expect(user.username).not_to eq('ab')
      end

      it 'renders success response' do
        patch user_path(user), params: { user: params }
        user.reload
        expect(response).to be_successful
      end

      it 'shows flash danger' do
        patch user_path(user), params: { user: params }
        user.reload
        expect(flash[:danger]).to be_present
      end

      it 'shows error message' do
        patch user_path(user), params: { user: params }
        user.reload
        expect(page).to include(I18n.t('activerecord.errors.models.user.attributes.username.too_short'))
      end

      it 'renders edit page' do
        patch user_path(user), params: { user: params }
        expect(response).to render_template(:edit)
      end
    end

    context 'when trying to update another user account' do
      let!(:another_user) { create(:user) }
      let(:params) { { username: 'Dave123', password: 'somepassword' } }

      it 'does not update another user' do
        patch user_path(another_user), params: { user: params }
        expect(response).to redirect_to(user_path(user))
      end
    end
  end

  describe 'DELETE /destroy' do
    before { authenticate(user) }

    it 'destroys the User account' do
      expect do
        delete user_path(user)
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the sign up page' do
      delete user_path(user)
      expect(response).to redirect_to(signup_path)
    end
  end
end
