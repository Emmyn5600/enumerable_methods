require_relative '../enumerable'

describe Enumerable do
  let(:array) { %w[apple Orange Watermelon Banana] }
  let(:hash) { { fruit: 'banana', phone: 'apple' } }
  let(:number_array) { [1, 2, 3, 4] }
  let(:arr) { [] }
  let(:false_arr) { [false] }
  let(:true_arr) { [1, 3, 5] }

  describe '#my_each' do
    it 'returns the array' do
      expect(array.my_each { |fruit| fruit }).to eql(array)
    end

    it 'returns the numbers if they are even' do
      expect(number_array.my_each do |number|
               number if number.even?
             end).to eql(number_array.each do |number|
                           number if number.even?
                         end)
    end

    it 'my_each when self is a hash' do
      expect(hash.my_each do |keys, value|
               keys if value == 'banana'
             end).to eql(hash.each do |keys, value|
                           keys if value == 'banana'
                         end)
    end

    it 'does not return a transformed array' do
      expect(number_array.my_each { |n| n * 2 }).not_to eq([2, 4, 6, 8])
    end
  end

  describe '#my_each_with_index' do
    it 'returns the doubled indexes for an array' do
      expect(number_array.my_each_with_index do |_number, index|
               index * 2
             end).to eql(number_array.each_with_index do |_number, index|
                           index * 2
                         end)
    end

    it 'returns all elements that are even index' do
      expect(number_array.my_each_with_index do |number, index|
               number if index.even?
             end).to eql(number_array.each_with_index do |number, index|
                           number if index.even?
                         end)
    end

    it 'returns hash if an index for key is 1' do
      expect(hash.my_each_with_index { |hash, index| hash if index == 1 }).to eql(hash.each_with_index do |hash, index|
                                                                                    hash if index == 1
                                                                                  end)
    end

    it 'does not return a transformed array' do
      expect(number_array.my_each_with_index { |n, index| n * 2 if index.even? }).not_to eq([2, 2, 6, 4])
    end
  end

  describe '#my_select' do
    it 'returns elements that have 6 letters' do
      expect(array.my_select { |word| word if word.length == 6 }).to eq(%w[Orange Banana])
    end

    it 'returns elements if you are trying to find elements that have less or greater than 6 letters' do
      expect(array.my_select { |word| word if word.length < 6 || word.length > 6 }).to eq(%w[apple Watermelon])
    end

    it 'returns all the numbers divisible by 2' do
      expect(number_array.my_select { |number| number if number.even? }).to eq([2, 4])
    end

    it 'does not modify the original array or return the transformed array' do
      test_array = [2, 4, 6, 8]
      new_array = test_array.my_select { |n| n * 2 }
      expect(new_array).to eq(test_array)
    end
  end

  describe '#my_all' do
    it 'returns true if we do not have a block' do
      expect(arr.my_all?).to be true
    end

    it 'returns a false if we do have a false element' do
      expect(false_arr.my_all?).to be false
    end

    it 'returns true if the all elements are odd numbers' do
      expect(true_arr.my_all? { |number| number if number.odd? }).to be true
    end

    it 'returns true if the all elements in the array matches the class' do
      expect(number_array.my_all?(Numeric)).to eql(true)
    end

    it 'returns true if the all elements contains letter a' do
      expect(array.my_all?(/a/)).to eql(true)
    end

    it 'returns a true if the elements in the array matches with parameter' do
      expect(['microverse'].my_all?('microverse')).to be true
    end

    it 'returns a false if the elements in the array does not matches with parameter' do
      expect(['microverse'].my_all?('microverseschool')).to be false
    end
  end

  describe 'my_any?' do
    it 'returns true if any elements are true with no block given' do
      expect([false, nil, true, 8].my_any?).to be true
    end

    it 'returns false if none of the elements are true' do
      expect(false_arr.my_any?).to be false
    end

    it 'returns true if any of the elements are even numbers' do
      expect(number_array.my_any?(&:even?)).to be true
    end

    it 'returns true if any of the elements matches the class' do
      expect([1, 'word', false].my_any?(Numeric)).to be true
    end

    it 'returns true if any of the elements contain the letter g' do
      expect(array.my_any?(/g/)).to eql(true)
    end

    it 'returns true if any of the elements matches the parameter' do
      expect([true, 'microverse', array].my_any?('microverse')).to be true
    end

    it 'returns false if nothing in the array matches with the block' do
      expect(number_array.my_any? { |number| number > 5 }).to be false
    end
  end

  describe '#my_none?' do
    it 'returns true if we do not have a block on an empty array' do
      expect(arr.my_none?).to be true
    end

    it 'returns a false if we only have false elements' do
      expect(false_arr.my_none?).to be true
    end

    it 'returns true if no elements match the block' do
      expect(number_array.my_none? { |number| number > 5 }).to be true
    end

    it 'returns true if no elements are from the given class' do
      expect(array.my_none?(Numeric)).to be true
    end

    it 'returns true if none of the elements contain the letter z' do
      expect(array.my_none?(/z/)).to be true
    end

    it 'returns true if none of the elements matches the parameter' do
      expect(%w[microverse freecodecamp odin_projects].my_none?('codecademy')).to be true
    end

    it 'returns false if any of the elements matches the block' do
      expect(number_array.my_none? { |number| number == 3 }).to be false
    end
  end

  describe '#my_count' do
    it 'returns the counted numbers of the elements that are in the array' do
      expect(number_array.my_count { |number| number + 1 }).to eql(number_array.count { |number| number + 1 })
    end

    it 'returns the counted elements that same as the passing parameters' do
      expect(%w[microverse microverse freecodecamp codeacademy].my_count('microverse')).to eql(2)
    end

    it 'does not return the original array if used without a block' do
      expect(array.my_count).not_to eq(array)
    end
  end

  describe '#my_map' do
    it 'returns an exponential of each elements that are in array' do
      expect(number_array.my_map { |number| number**2 }).to eq(number_array.map { |number| number**2 })
    end

    it 'returns the multiplication of each elements' do
      expect((0..10).my_map { |number| number * number }).to eq((0..10).map { |number| number * number })
    end

    it 'changes the word small to the word long' do
      animal = ['Small Cat', 'Small Dog', 'Small Bird']
      to_expect = ['Big Cat', 'Big Dog', 'Big Bird']
      expect(animal.my_map { |animals| animals.gsub('Small', 'Big') }).to eq(to_expect)
    end

    it 'does not change the initial array' do
      initial_array = [1, 2, 9, 10]
      mapped_array = initial_array.my_map { |n| n * 2 }
      expect(initial_array).not_to eq(mapped_array)
    end
  end

  describe '#my_inject' do
    it 'returns the sum of all numbers in the array' do
      expect(number_array.my_inject { |sum, number| sum + number }).to eq(10)
    end

    it 'returns the longest word' do
      biggest_word = array.my_inject do |word1, word2|
        word1.length > word2.length ? word1 : word2
      end
      expect(biggest_word).to eql('Watermelon')
    end

    it 'always returns the product of the operator independent of the keyword used' do
      expect(number_array.my_inject { |sum, n| sum * n }).not_to eq(10)
    end
  end
end
