require_relative '../spec_helper'

RSpec.describe Link, type: :model do
  let(:valid_params) {{ url: 'https://impraise.com', shortcode: 'imprse' }}
  let(:valid_without_shortcode_params) {{ url: 'https://impraise.com' }}
  let(:invalid_params) {{url: 'https://impraise.com' , shortcode: 'an_invalid_shortcode'}}

  it 'should have attributes' do
    expect(subject.class.instance_methods).to include(:url)
    expect(subject.class.instance_methods).to include(:shortcode)
    expect(subject.class.instance_methods).to include(:redirect_count)
    expect(subject.class.instance_methods).to include(:created_at)
    expect(subject.class.instance_methods).to include(:updated_at)
  end

  describe 'Create' do
    it 'should be valid with valid params' do
      link = Link.new(valid_params)
      expect(link.valid?).to eq true
    end

    it 'should generate a valid shortcode if non given' do
      link = Link.new(valid_without_shortcode_params)
      expect(link.valid?).to eq true
      expect(link.shortcode).not_to eq nil
      expect(link.shortcode.match("^[0-9a-zA-Z_]{6}$")).not_to eq nil
    end

    it 'should not be valid without url' do
      link = Link.new({})
      expect(link.valid?).to eq false
    end

    it 'should not be valid without a valid shortcode' do
      link = Link.new(invalid_params)
      expect(link.valid?).to eq false
    end

    it 'should save to redis when save method called' do
      link = Link.new(valid_params)
      link.save

      expect($redis.get(link.shortcode)).not_to eq nil
    end
  end
end
