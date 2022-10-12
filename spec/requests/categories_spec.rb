RSpec.describe 'Categories', type: :request do
  let(:user) { create(:user, password: Helpers::UserAuthHelper::PASSWORD) }
  let(:another_user) { create(:user) }
  let!(:category) { create(:category, user:) }
  let(:page) { Nokogiri::HTML.parse(response.body).text }

  describe 'GET /index' do
    let!(:categories_list) { create_list(:category, 3, user:) }

    context 'when get index page of category list' do
      before do
        authenticate(user)
        get categories_path
      end

      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'shows categories headings' do
        categories_list.map { |item| expect(page).to include(item.heading) }
      end

      it 'shows show button' do
        expect(page).to include(I18n.t('category.links.show'))
      end

      it 'shows edit button' do
        expect(page).to include(I18n.t('category.links.edit'))
      end

      it 'shows destroy button' do
        expect(page).to include(I18n.t('category.links.destroy'))
      end
    end

    context 'when get page as unregistered user' do
      before { get categories_path }

      it 'redirects to the signup page' do
        expect(response).to redirect_to(signup_path)
      end
    end
  end

  describe 'GET /show' do
    context 'when get show category page' do
      before do
        authenticate(user)
        get category_path(category)
      end

      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'shows the heading' do
        expect(page).to include(category.heading)
      end

      it 'shows the body' do
        expect(page).to include(category.body)
      end
    end

    context 'when trying to access another user category page' do
      let(:category) { create(:category, user: another_user) }

      before do
        authenticate(user)
        get category_path(category)
      end

      it 'renders 404 response' do
        expect(response).to have_http_status(:not_found)
      end

      it 'shows the title' do
        expect(page).to include("The page you were looking for doesn't exist.")
      end
    end

    context 'when unregistered' do
      before { get category_path(category) }

      it 'redirects to the signup page' do
        expect(response).to redirect_to(signup_path)
      end
    end
  end

  describe 'GET /new' do
    context 'when get new page of category' do
      before do
        authenticate(user)
        get new_category_path
      end

      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'shows the title' do
        expect(page).to include(I18n.t('category.new.title'))
      end
    end

    context 'when unregistered' do
      before { get new_category_path }

      it 'redirects to the signup page' do
        expect(response).to redirect_to(signup_path)
      end
    end
  end

  describe 'GET /edit' do
    context 'when current user' do
      before do
        authenticate(user)
        get edit_category_path(category)
      end

      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'renders right template' do
        expect(response).to render_template(:edit)
      end

      it 'shows edit page title' do
        expect(page).to include(I18n.t('category.edit.title'))
      end
    end

    context 'when get edit page of another user' do
      let(:category) { create(:category, user: another_user) }

      before do
        authenticate(user)
        get edit_category_path(category)
      end

      it 'renders 404 response' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when unregistered' do
      before { get edit_category_path(category) }

      it 'redirects to the signup page' do
        expect(response).to redirect_to(signup_path)
      end
    end
  end

  describe 'POST /create' do
    before { authenticate(user) }

    context 'with valid parameters' do
      let(:params) do
        { heading: 'Traveling',
          user_id: user.id,
          body: 'Traveling for a long distance.' }
      end

      it 'creates a new category' do
        expect do
          post categories_path, params: { category: params }
        end.to change(Category, :count).by(1)
      end

      it 'renders success flash' do
        post categories_path, params: { category: params }
        expect(flash[:success]).to be_present
      end

      it 'renders success message' do
        post categories_path, params: { category: params }
        follow_redirect!
        expect(response.body).to include(I18n.t('category.success.created'))
      end

      it 'redirects to the show page' do
        post categories_path, params: { category: params }
        follow_redirect!
        expect(response).to render_template(:show)
      end
    end

    context 'with invalid parameters' do
      let(:params) do
        { heading: '',
          user_id: user.id }
      end

      it 'does not create a new category' do
        expect do
          post categories_path, params: { category: params }
        end.not_to change(Category, :count)
      end

      it 'renders danger flash' do
        post categories_path, params: { category: params }
        expect(flash[:danger]).to be_present
      end

      it 'renders danger message' do
        post categories_path, params: { category: params }
        expect(response.body).to include(I18n.t('activerecord.errors.models.category.attributes.heading.blank'))
      end

      it 'renders success response' do
        post categories_path, params: { category: params }
        expect(response).to be_successful
      end

      it 'renders new page' do
        post categories_path, params: { category: params }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT /update' do
    let(:category) { create(:category, heading: 'Home', body: 'Some description.', user:) }

    context 'when valid params' do
      before { authenticate(user) }

      let(:params) do
        { heading: 'New Heading',
          user_id: user.id,
          body: 'New body description.' }
      end

      it 'updates the heading' do
        put category_path(category), params: { category: params }
        category.reload
        expect(category.heading).to eq('New Heading')
      end

      it 'updates the body' do
        put category_path(category), params: { category: params }
        category.reload
        expect(category.body).to eq('New body description.')
      end

      it 'redirects to the category page' do
        put category_path(category), params: { category: params }
        expect(response).to redirect_to(category_path(category))
      end

      it 'renders right template' do
        put category_path(category), params: { category: params }
        follow_redirect!
        expect(response).to render_template(:show)
      end

      it 'renders success flash' do
        put category_path(category), params: { category: params }
        expect(flash[:success]).to be_present
      end

      it 'renders success message' do
        put category_path(category), params: { category: params }
        follow_redirect!
        expect(response.body).to include(I18n.t('category.success.updated'))
      end
    end

    context 'with invalid parameters' do
      before { authenticate(user) }

      let(:params) do
        { heading: '',
          user_id: user.id,
          body: 'Body of invalid object.' }
      end

      it 'does not update heading' do
        put category_path(category), params: { category: params }
        category.reload
        expect(category.heading).to eq('Home')
      end

      it 'does not update body' do
        put category_path(category), params: { category: params }
        category.reload
        expect(category.body).to eq('Some description.')
      end

      it 'renders danger flash' do
        put category_path(category), params: { category: params }
        expect(flash[:danger]).to be_present
      end

      it 'renders danger message' do
        put category_path(category), params: { category: params }
        expect(response.body).to include(I18n.t('activerecord.errors.models.category.attributes.heading.blank'))
      end

      it 'renders success response' do
        put category_path(category), params: { category: params }
        expect(response).to be_successful
      end

      it 'renders edit page' do
        put category_path(category), params: { category: params }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when authenticated' do
      before { authenticate(user) }

      it 'destroys the category' do
        expect do
          delete category_path(category)
        end.to change(Category, :count).by(-1)
      end

      it 'redirects to the all categories page' do
        delete category_path(category)
        expect(response).to redirect_to(categories_path)
      end

      it 'renders informational flash' do
        delete category_path(category)
        expect(flash[:info]).to be_present
      end

      it 'renders info message' do
        delete category_path(category)
        follow_redirect!
        expect(response.body).to include(I18n.t('category.success.destroyed'))
      end
    end

    context 'when unregistered' do
      before { delete category_path(category) }

      it 'redirects to the signup page' do
        expect(response).to redirect_to(signup_path)
      end
    end
  end
end
