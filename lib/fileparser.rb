# fileparser.rb

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
    @data = data_modifier(@data)
  end

  def sort_all_data
    self.get_all_data
    self.format_all_data

    puts
    puts "Output 1"
    puts

    x = output_1(@data)
    x.each{|x| p x}

    puts
    puts "Output 2"
    puts

    y = output_2(@data)
    y.each{|y| p y}

    puts
    puts "Output 3"
    puts

    z = output_3(@data)
    z.each{|z| p z}
  end

  def output_1(data) #sort by gender and last name
    data = data.sort!{|a,b| [a[2],a[0]]<=>[b[2],b[0]]}
  end

  def output_2(data) #sort by birthday
    data = data.sort_by!{|a| m,d,y=a[3].split("/").map{|x| x.to_i};[y,m,d]}
  end

  def output_3(data) #sort by last name descending
    data = data.sort!{|a,b| b[0]<=>a[0]}
  end

  def fileopener(txt_file)
    if File.exists?(txt_file)
      File.foreach(txt_file) do |a|
        case
          when a.include?(",")
            @data << a.split(",")
          when a.include?("|")
            @data << a.split("|")
          else
            @data << a.split(" ")
        end
      end
      @data
    else
      "File does not exist"
    end
  end

  def data_modifier(data)
    data.each do |p|
      midname_modifier(p)
      gender_modifier(p)
      date_mover(p)
      date_modifier(p)
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

  def date_mover(date)
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

end

fp = FileParser.new
fp.sort_all_data


