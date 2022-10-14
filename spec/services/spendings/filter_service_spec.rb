RSpec.describe Spendings::FilterService, type: :service do
  describe '.call' do
    let(:user) { create(:user) }
    let(:category_first) { create(:category, heading: 'Travelling', user:) }
    let(:category_second) { create(:category, heading: 'Home', user:) }
    let(:category_third) { create(:category, heading: 'Food', user:) }
    let(:spendings) do
      [create(:spending, user:, category: category_first, amount: 10),
       create(:spending, user:, category: category_second, amount: 25),
       create(:spending, user:, category: category_first, amount: 100),
       create(:spending, user:, category: category_second, amount: 50),
       create(:spending, user:, category: category_third, amount: 70)]
    end

    context 'when filter by category' do
      let(:params) { { category: category_first.heading } }
      let(:filtered_spendings) do
        [spendings[0],
         spendings[2]]
      end

      let(:wrong_spendings) do
        [spendings[1],
         spendings[3],
         spendings[4]]
      end

      it 'success result' do
        expect(described_class.call(params, user)).to match_array(filtered_spendings)
      end

      it 'does not include spendings of other categories' do
        wrong_spendings.map { |spending| expect(described_class.call(params, user)).not_to include(spending) }
      end
    end

    context 'when filter by min & max values' do
      let(:params) { { min: '10', max: '50' } }
      let(:filtered_spendings) do
        [spendings[0],
         spendings[1],
         spendings[3]]
      end

      let(:wrong_spendings) do
        [spendings[2],
         spendings[4]]
      end

      it 'success result' do
        expect(described_class.call(params, user)).to match_array(filtered_spendings)
      end

      it 'does not include spendings of other amounts' do
        wrong_spendings.map { |spending| expect(described_class.call(params, user)).not_to include(spending) }
      end
    end

    context 'when filter by min value' do
      let(:params) { { min: '50' } }
      let(:filtered_spendings) do
        [spendings[2],
         spendings[3],
         spendings[4]]
      end

      let(:wrong_spendings) do
        [spendings[0],
         spendings[1]]
      end

      it 'success result' do
        expect(described_class.call(params, user)).to match_array(filtered_spendings)
      end

      it 'does not include spendings of other amounts' do
        wrong_spendings.map { |spending| expect(described_class.call(params, user)).not_to include(spending) }
      end
    end

    context 'when filter by max value' do
      let(:params) { { max: '25' } }
      let(:filtered_spendings) do
        [spendings[0],
         spendings[1]]
      end

      let(:wrong_spendings) do
        [spendings[2],
         spendings[3],
         spendings[4]]
      end

      it 'success result' do
        expect(described_class.call(params, user)).to match_array(filtered_spendings)
      end

      it 'does not include spendings of other amounts' do
        wrong_spendings.map { |spending| expect(described_class.call(params, user)).not_to include(spending) }
      end
    end

    context 'when mix of parameters' do
      let(:params) { { min: '17', max: '100', category: category_second.heading } }
      let(:filtered_spendings) do
        [spendings[1],
         spendings[3]]
      end

      let(:wrong_spendings) do
        [spendings[0],
         spendings[2],
         spendings[4]]
      end

      it 'success result' do
        expect(described_class.call(params, user)).to match_array(filtered_spendings)
      end

      it 'does not include spendings that are not matched' do
        wrong_spendings.map { |spending| expect(described_class.call(params, user)).not_to include(spending) }
      end
    end

    context 'when empty params' do
      let(:params) { {} }

      it 'success result' do
        expect(described_class.call(params, user)).to match_array(spendings)
      end
    end
  end
end
