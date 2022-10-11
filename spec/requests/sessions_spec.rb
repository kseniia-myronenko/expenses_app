RSpec.describe 'Sessions', type: :request do
  let!(:user) { create(:user, password: 'securepassword') }
  let(:page) { Nokogiri::HTML.parse(response.body).text }

  describe 'GET /new' do
    before { get login_path }

    it 'renders a successful response' do
      expect(response).to be_successful
    end

    it 'shows form title' do
      expect(page).to include(I18n.t('authentication.form.log_in'))
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'redirects to the main page' do
        post login_path(username: user.username, password: 'securepassword')
        expect(response).to redirect_to(root_path)
      end

      it 'renders success flash' do
        post login_path(username: user.username, password: 'securepassword')
        expect(flash[:success]).to be_present
      end

      it 'renders success message' do
        post login_path(username: user.username, password: 'securepassword')
        get root_path
        expect(page).to include(I18n.t('authentication.success.logged_in'))
      end
    end

    context 'with invalid parameters' do
      it 'renders log in page' do
        post login_path(username: 'mike', password: 'password')
        expect(response).to be_successful
      end

      it 'renders danger flash' do
        post login_path(username: 'mike', password: 'password')
        expect(flash[:danger]).to be_present
      end

      it 'shows error message' do
        post login_path(username: 'mike', password: 'password')
        expect(page).to include(I18n.t('authentication.errors.wrong_data'))
      end
    end
  end

  describe 'DELETE /destroy' do
    before { authenticate(user) }

    it 'redirects to the sign up page' do
      get logout_path(user)
      expect(response).to redirect_to(signup_path)
    end

    it 'renders success flash' do
      get logout_path(user)
      expect(flash[:success]).to be_present
    end

    it 'renders success message' do
      get logout_path(user)
      get signup_path
      expect(page).to include(I18n.t('authentication.success.logged_out'))
    end
  end
end
