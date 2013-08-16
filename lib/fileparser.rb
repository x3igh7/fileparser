# fileparser.rb'
require 'csv'

class FileParser

  def initialize()
    @txt_files = []
    @data = []
  end

  def get_all_data
    Dir.glob("./files/*.txt") do |txt_file|
      @data = fileopener(txt_file)
    end
    @data
  end

  def format_all_data
    data = data_modifier(@data)
    @data = map_to_hash(data)
  end

  def sort_all_data
    self.get_all_data
    self.format_all_data

    puts
    puts "Output 1"
    puts "--------"

    people_by_gender_name = output_1(@data)
    people_by_gender_name.each{|x| puts x.map{|k,v| "#{v}"}.join(' ')}

    puts
    puts "Output 2"
    puts "--------"

    people_by_age = output_2(@data)
    people_by_age.each{|x| puts x.map{|k,v| "#{v}"}.join(' ')}

    puts
    puts "Output 3"
    puts "--------"

    people_by_name = output_3(@data)
    people_by_name.each{|x| puts x.map{|k,v| "#{v}"}.join(' ')}
  end

  def output_1(data) #sort by gender and last name
    @data = data.sort!{|a,b| [a[:gender],a[:last_name]]<=>[b[:gender],b[:last_name]]}
  end

  def output_2(data) #sort by birthday
    sorted_data = data.sort_by!{|a| m,d,y=a[:birthday].split("/").map{|x| x.to_i};[y,m,d]}
  end

  def output_3(data) #sort by last name descending
    sorted_data = data.sort!{|a,b| b[:last_name]<=>a[:last_name]}
  end

  def fileopener(txt_file)
    if File.exists?(txt_file)
      type = detect_file_type(txt_file)
      case
        when type == "csv"
          CSV.foreach(txt_file) do |row|
            @data << row
          end
        when type == "psv"
          CSV.foreach(txt_file, col_sep: '|') do |row|
            @data << row
          end
        when type == "ssv"
          CSV.foreach(txt_file, col_sep: ' ') do |row|
            @data << row
          end
      end
      @data
    else
      "File does not exist"
    end
  end

  def detect_file_type(file)
    File.foreach(file) do |row|
      case
        when row.include?(",")
          return "csv"
          break
        when row.include?("|")
          return "psv"
          break
        else
          return "ssv"
          break
      end
    end
  end

  def data_modifier(data)
    data.each do |row|
      midname_modifier(row)
      gender_modifier(row)
      date_mover(row)
      date_modifier(row)
    end
    data
  end

  def gender_modifier(gender)
    gender.map! do |gender|
      gender.strip!
      if gender == "M"
        "Male"
      elsif gender == "F"
        "Female"
      else
        gender
      end
    end
  end

  def midname_modifier(middlename)
    x = nil
    middlename.each_with_index do |mi, i|
      mi.strip!
      if mi.length == 1
        x = i
        break
      end
    end
    if x != nil
      middlename.delete_at(x)
    end
  end

  def date_mover(date) #puts the date into the correct position
    x = nil
    date.each_with_index do |date, i|
      date.strip!
      if date.include?("19" || "20")
        x = i
      end
    end
    if x != nil
      date.insert((date.length - 2), date.delete_at(x))
    end
  end


  def date_modifier(date)
    date[(date.length-2)].gsub!(/-/,"/")
  end

  def map_to_hash(data)
    keys = [:last_name, :first_name, :gender, :birthday, :color]
    data = data.map!{|x| Hash[keys.zip(x)]}
  end

end

fp = FileParser.new
fp.sort_all_data


