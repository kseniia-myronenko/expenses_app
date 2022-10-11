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
      let(:params) { attributes_for(:user) }

      it 'redirects to the main page' do
        post login_path(username: user.username, password: 'securepassword')
        expect(response).to redirect_to(root_path)
      end
    end

    #   context 'with invalid parameters' do
    #     let(:params) { { username: '' } }

    #     it 'does not create a new User' do
    #       expect {
    #         post signup_path, params: { user: params }
    #       }.not_to change(User, :count)
    #     end

    #     it 'redirects to the sign up page' do
    #       post signup_path, params: { user: params }
    #       expect(response).to redirect_to(signup_path)
    #     end
    #   end
  end
end
