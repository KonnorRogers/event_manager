require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

# EventManager using google apis for voting purposes
# files are stored as a CSV for readibility and ease of access
#
class EventManager
  def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, '0')[0..4]
  end

  def legislators_by_zipcode(zip)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
    begin
      civic_info.representative_info_by_address(
        address: zip, levels: 'country',
        roles: %w[legislatorUpperBody legislatorLowerBody]
      ).officials
    rescue StandardError
      'visit www.commoncause.org/take-action/find-elected-officials'
    end
  end

  def format_phone_numbers(number)
    number.gsub!(/\D+/, '')
    # strips the phone number to provide an accurate count
    return 'invalid.' unless number.length.between?(10, 11)
    return 'invalid.' if number.size == 11 && number[0].to_i != 1

    number = number.to_s.slice!(1, number.length) if number.length == 11

    format_number(number)
  end

  def format_number(number)
    extension = number.to_s.slice!(0, 3).split
    extension.unshift('(')
    extension.push(')-')

    last_four = number.to_s.slice!(-4, 4).split
    last_four.unshift('-')

    extension.join + number + last_four.join
  end

  def save_thank_you_letters(id, form_letter)
    Dir.mkdir('output') unless Dir.exist?('output')
    filename = "output/thanks_#{id}.html"

    File.open(filename, 'w') do |file|
      file.puts form_letter
    end
  end

  def read_csv
    CSV.open(
      'event_attendees.csv',
      headers: true,
      header_converters: :symbol
    )
  end

  def erb_template_letter
    template_letter = File.read('form_letter.erb')
    ERB.new(template_letter)
  end

  def write_files
    erb_template = erb_template_letter

    read_csv.each do |row|
      id = row[0]
      name = row[:first_name]
      zipcode = clean_zipcode(row[:zipcode])

      phone_number = format_phone_numbers(row[:homephone])

      legislators = legislators_by_zipcode(zipcode)

      form_letter = erb_template.result(binding)
      save_thank_you_letters(id, form_letter)
    end
  end

  def run
    puts 'Event Manager initialized!'
    write_files
  end
end

EventManager.new.run
