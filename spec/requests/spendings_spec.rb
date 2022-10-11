RSpec.describe 'Spendings', type: :request do
  let(:user) { create(:user, password: Helpers::UserAuthHelper::PASSWORD) }
  let(:category) { create(:category) }
  let!(:spending) { create(:spending, user:, category:) }
  let!(:spending_list) { create_list(:spending, 3, user:, category:) }
  let(:page) { Nokogiri::HTML.parse(response.body).text }

  describe 'GET /index' do
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
    end

    context 'when get amount list of another user' do
      let(:another_user) { create(:user) }
      let!(:spending_list) { create_list(:spending, 3, user: another_user, category:) }

      before do
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
    end
  end

  describe 'GET /show' do
    context 'when get show page of amount' do
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
  end
end
