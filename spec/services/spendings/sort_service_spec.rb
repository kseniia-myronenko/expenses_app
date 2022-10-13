RSpec.describe Spendings::SortService, type: :service do
  describe '.call' do
    let(:user) { create(:user) }
    let(:spendings) { user.spendings }
    let(:category) { create(:category) }

    before do
      [create(:spending, user:, category:, amount: 10),
       create(:spending, user:, category:, amount: 25),
       create(:spending, user:, category:, amount: 100),
       create(:spending, user:, category:, amount: 50),
       create(:spending, user:, category:, amount: 70)]
    end

    context 'when sort by asc' do
      let(:params) { { sort: 'asc' } }
      let(:sorted_spendings) do
        [spendings[0],
         spendings[1],
         spendings[3],
         spendings[4],
         spendings[2]]
      end

      it 'sorts by asc order' do
        expect(described_class.call(spendings, params)).to match_array(sorted_spendings)
      end
    end

    context 'when sort by desc' do
      let(:params) { { sort: 'desc' } }
      let(:sorted_spendings) do
        [spendings[2],
         spendings[4],
         spendings[3],
         spendings[1],
         spendings[0]]
      end

      it 'sorts by desc order' do
        expect(described_class.call(spendings, params)).to match_array(sorted_spendings)
      end
    end
  end
end
