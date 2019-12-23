class Link
  attr_accessor :shortcode, :url, :redirect_count, :created_at, :updated_at, :errors

  def initialize(params)
    self.shortcode      = params['shortcode'] || params[:shortcode] || generate_shortcode
    self.url            = params['url'] || params[:url]
    self.redirect_count = params['redirect_count'] || 0
    self.created_at     = params['created_at'] || formatted_current_time
    self.updated_at     = params['updated_at'] || formatted_current_time
    self.errors         = []
  end

  def self.find(shortcode)
    redis_record = $redis.get(shortcode)
    return nil if redis_record.nil?
    Link.new(JSON.parse(redis_record))
  end

  def save
    $redis.set(self.shortcode, redis_hash)
  end

  def valid?
    errors.push(OpenStruct.new({
                                   status: 400,
                                   message: 'Url is not present.'
                               })) if self.url.nil?

    errors.push(OpenStruct.new({
                                   status: 422,
                                   message: 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.'
                               })) if regex_check(self.shortcode)

    errors.push(OpenStruct.new({
                                   status: 409,
                                   message: 'The the desired shortcode is already in use.'
                               })) unless Link.find(self.shortcode).nil?
    !errors.any?
  end

  def to_json
    {
        startDate: self.created_at,
        lastSeenDate: self.updated_at,
        redirectCount: self.redirect_count
    }.to_json
  end

  def increase_counter
    self.redirect_count = redirect_count + 1
    self.updated_at = formatted_current_time
    save
  end

  private
  def redis_hash
    {
        shortcode: self.shortcode,
        url: self.url,
        created_at: self.created_at,
        updated_at: self.updated_at,
        redirect_count: self.redirect_count
    }.to_json
  end

  def generate_shortcode
    [('a'..'z'), ('A'..'Z'),['_', '-']].map(&:to_a).flatten.sample(6).join
  end

  def formatted_current_time
    Time.now.strftime('%Y-%m-%dT%H:%M:%S.%L%z')
  end

  def regex_check(shortcode)
    shortcode.nil? || shortcode.match("^[0-9a-zA-Z_]{6}$").nil?
  end
end