RSpec.describe 'Spendings', type: :request do
  let(:user) { create(:user, password: Helpers::UserAuthHelper::PASSWORD) }
  let(:another_user) { create(:user) }
  let(:category) { create(:category) }
  let!(:spending) { create(:spending, user:, category:) }
  let(:page) { Nokogiri::HTML.parse(response.body).text }

  describe 'GET /index' do
    let!(:spending_list) { create_list(:spending, 3, user:, category:) }

    context 'when get index page of amount list' do
      before do
        authenticate(user)
        get user_spendings_path(user)
      end

      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'shows amounts list' do
        spending_list.map { |item| expect(page).to include(item.amount.to_s) }
      end

      it 'shows descriptions' do
        spending_list.map { |item| expect(page).to include(item.description) }
      end

      it 'shows amounts categories' do
        spending_list.map { |item| expect(page).to include(item.category.heading) }
      end

      it 'shows edit button' do
        expect(page).to include(I18n.t('spending.links.edit'))
      end

      it 'shows destroy button' do
        expect(page).to include(I18n.t('spending.links.destroy'))
      end
    end

    context 'when get amount list of another user' do
      let!(:spending_list) { create_list(:spending, 3, user: another_user, category:) }

      before do
        authenticate(user)
        get user_spendings_path(another_user)
      end

      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'shows amounts list' do
        spending_list.map { |item| expect(page).to include(item.amount.to_s) }
      end

      it 'shows descriptions' do
        spending_list.map { |item| expect(page).to include(item.description) }
      end

      it 'shows amounts categories' do
        spending_list.map { |item| expect(page).to include(item.category.heading) }
      end

      it 'does not show edit button' do
        expect(page).not_to include(I18n.t('spending.links.edit'))
      end

      it 'does not show destroy button' do
        expect(page).not_to include(I18n.t('spending.links.destroy'))
      end
    end

    context 'when unregistered get amount list of another user' do
      before { get user_spendings_path(another_user) }

      it 'redirects to the signup page' do
        expect(response).to redirect_to(signup_path)
      end
    end
  end

  describe 'GET /show' do
    context 'when get show amount page' do
      before do
        authenticate(user)
        get user_spending_path(user, spending)
      end

      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'shows the amount' do
        expect(page).to include(spending.amount.to_s)
      end

      it 'shows the description' do
        expect(page).to include(spending.description)
      end

      it 'shows the category' do
        expect(page).to include(spending.category.heading)
      end
    end

    context 'when trying to access another user show amount page' do
      let(:spending) { create(:spending, user: another_user, category:) }

      before do
        authenticate(user)
        get user_spending_path(another_user, spending)
      end

      it 'renders 404 response' do
        expect(response).to have_http_status(:not_found)
      end

      it 'shows the title' do
        expect(page).to include("The page you were looking for doesn't exist.")
      end
    end

    context 'when unregistered' do
      before { get user_spending_path(another_user, spending) }

      it 'redirects to the signup page' do
        expect(response).to redirect_to(signup_path)
      end
    end
  end

  describe 'GET /new' do
    context 'when get new page of own spending' do
      before do
        authenticate(user)
        get new_user_spending_path(user)
      end

      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'shows the title' do
        expect(page).to include(I18n.t('spending.new.title'))
      end
    end

    context 'when get new page of another user spending' do
      before do
        authenticate(user)
        get new_user_spending_path(another_user)
      end

      it 'renders 404 response' do
        expect(response).to have_http_status(:not_found)
      end

      it 'shows the title' do
        expect(page).to include("The page you were looking for doesn't exist.")
      end
    end

    context 'when unregistered' do
      before { get new_user_spending_path(another_user) }

      it 'redirects to the signup page' do
        expect(response).to redirect_to(signup_path)
      end
    end
  end

  describe 'GET /edit' do
    context 'when current user' do
      before do
        authenticate(user)
        get edit_user_spending_path(user, spending)
      end

      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'renders right template' do
        expect(response).to render_template(:edit)
      end

      it 'shows edit page title' do
        expect(page).to include(I18n.t('spending.edit.title'))
      end
    end

    context 'when get edit page of another user' do
      let(:spending) { create(:spending, user: another_user, category:) }

      before do
        authenticate(user)
        get edit_user_spending_path(user, spending)
      end

      it 'renders 404 response' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when unregistered' do
      before { get edit_user_spending_path(user, spending) }

      it 'redirects to the signup page' do
        expect(response).to redirect_to(signup_path)
      end
    end
  end

  describe 'POST /create' do
    before { authenticate(user) }

    context 'with valid parameters' do
      let(:params) do
        { amount: '200',
          category_id: create(:category).id,
          user_id: user.id,
          description: 'For food.' }
      end

      it 'creates a new spending' do
        expect do
          post user_spendings_path(user), params: { spending: params }
        end.to change(Spending, :count).by(1)
      end

      it 'renders success flash' do
        post user_spendings_path(user), params: { spending: params }
        expect(flash[:success]).to be_present
      end

      it 'renders success message' do
        post user_spendings_path(user), params: { spending: params }
        follow_redirect!
        expect(response.body).to include(I18n.t('spending.success.created'))
      end

      it 'redirects to the show page' do
        post user_spendings_path(user), params: { spending: params }
        follow_redirect!
        expect(response).to render_template(:show)
      end
    end

    context 'with invalid parameters' do
      let(:params) do
        { amount: '',
          category_id: create(:category).id,
          user_id: user.id,
          description: 'For food.' }
      end

      it 'does not create a new spending' do
        expect do
          post user_spendings_path(user), params: { spending: params }
        end.not_to change(Spending, :count)
      end

      it 'renders danger flash' do
        post user_spendings_path(user), params: { spending: params }
        expect(flash[:danger]).to be_present
      end

      it 'renders danger message' do
        post user_spendings_path(user), params: { spending: params }
        expect(response.body).to include(I18n.t('activerecord.errors.models.spending.attributes.amount.blank'))
      end

      it 'renders success response' do
        post user_spendings_path(user), params: { spending: params }
        expect(response).to be_successful
      end

      it 'renders new page' do
        post user_spendings_path(user), params: { spending: params }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT /update' do
    let(:spending) { create(:spending, amount: '300', user:, category:) }

    context 'when valid params' do
      before { authenticate(user) }

      let(:params) do
        { amount: '200',
          category_id: create(:category).id,
          user_id: user.id,
          description: 'For animals.' }
      end

      it 'updates the amount' do
        put user_spending_path(user, spending), params: { spending: params }
        spending.reload
        expect(spending.amount).to eq(200)
      end

      it 'updates the description' do
        put user_spending_path(user, spending), params: { spending: params }
        spending.reload
        expect(spending.description).to eq('For animals.')
      end

      it 'redirects to the amount page' do
        put user_spending_path(user, spending), params: { spending: params }
        expect(response).to redirect_to(user_spending_path(user, spending))
      end

      it 'renders right template' do
        put user_spending_path(user, spending), params: { spending: params }
        follow_redirect!
        expect(response).to render_template(:show)
      end

      it 'renders success flash' do
        put user_spending_path(user, spending), params: { spending: params }
        expect(flash[:success]).to be_present
      end

      it 'renders success message' do
        put user_spending_path(user, spending), params: { spending: params }
        follow_redirect!
        expect(response.body).to include(I18n.t('spending.success.updated'))
      end
    end

    context 'with invalid parameters' do
      before { authenticate(user) }

      let(:params) do
        { amount: '',
          category_id: create(:category).id,
          user_id: user.id,
          description: 'For animals.' }
      end

      it 'does not update spending' do
        put user_spending_path(user, spending), params: { spending: params }
        spending.reload
        expect(spending.amount).to eq(300)
      end

      it 'renders danger flash' do
        put user_spending_path(user, spending), params: { spending: params }
        expect(flash[:danger]).to be_present
      end

      it 'renders danger message' do
        put user_spending_path(user, spending), params: { spending: params }
        expect(response.body).to include(I18n.t('activerecord.errors.models.spending.attributes.amount.blank'))
      end

      it 'renders success response' do
        put user_spending_path(user, spending), params: { spending: params }
        expect(response).to be_successful
      end

      it 'renders edit page' do
        put user_spending_path(user, spending), params: { spending: params }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when registered' do
      before { authenticate(user) }

      it 'destroys the spending' do
        expect do
          delete user_spending_path(user, spending)
        end.to change(Spending, :count).by(-1)
      end

      it 'redirects to the all spendings page' do
        delete user_spending_path(user, spending)
        expect(response).to redirect_to(user_spendings_path)
      end
    end

    context 'when unregistered' do
      before { delete user_spending_path(user, spending) }

      it 'redirects to the signup page' do
        expect(response).to redirect_to(signup_path)
      end
    end
  end
end
