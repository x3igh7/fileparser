# fileparser_spec.rb
require_relative '../lib/fileparser'

describe FileParser do

  before(:each) do
    @x = FileParser.new
  end

  context "get all data" do

    it "opens all files and compiles the data" do
      data = @x.get_all_data
      expect(data.length).to eq(9)
      expect(data[0]).to eq(["Abercrombie", " Neil", " Male", " Tan", " 2/13/1943"])
      expect(data[7]).to eq(["Hingis", "Martina", "M", "F", "4-2-1979", "Green"])
    end

  end

  context "format all data" do

    it "maps all arrays to hashes" do
      data = @x.get_all_data
      data = @x.data_modifier(data)
      @x.map_to_hash(data)
      expect(data[0]).to eq({:last_name=>"Abercrombie", :first_name=>"Neil", :gender=>"Male", :birthday=>"2/13/1943", :color=>"Tan"})
    end

    it "correctly formats the data" do
      data = @x.get_all_data
      @x.format_all_data
      expect(data[0]).to eq( {:last_name=>"Abercrombie", :first_name=>"Neil", :gender=>"Male", :birthday=>"2/13/1943", :color=>"Tan"})
      expect(data[7]).to eq({:last_name=>"Hingis", :first_name=>"Martina", :gender=>"Female", :birthday=>"4/2/1979", :color=>"Green"})
    end

  end

  context "data sorting" do

    it "sorts by gender then by last name, ascending" do
      data = @x.get_all_data
      data = @x.format_all_data
      @x.output_1(data)
      expect(data.first).to eq({:last_name=>"Hingis", :first_name=>"Martina", :gender=>"Female", :birthday=>"4/2/1979", :color=>"Green"})
      expect(data.last).to eq({:last_name=>"Smith", :first_name=>"Steve", :gender=>"Male", :birthday=>"3/3/1985", :color=>"Red"})
    end

    it "sorts by birthday, ascending" do
      data = @x.get_all_data
      data = @x.format_all_data
      @x.output_2(data)
      expect(data.first).to eq({:last_name=>"Abercrombie", :first_name=>"Neil", :gender=>"Male", :birthday=>"2/13/1943", :color=>"Tan"})
      expect(data.last).to eq({:last_name=>"Smith", :first_name=>"Steve", :gender=>"Male", :birthday=>"3/3/1985", :color=>"Red"})
    end

    it "sorts by last name, descending" do
      data = @x.get_all_data
      data = @x.format_all_data
      @x.output_3(data)
      expect(data.first).to eq({:last_name=>"Smith", :first_name=>"Steve", :gender=>"Male", :birthday=>"3/3/1985", :color=>"Red"})
      expect(data.last).to eq({:last_name=>"Abercrombie", :first_name=>"Neil", :gender=>"Male", :birthday=>"2/13/1943", :color=>"Tan"})
    end

  end

  context "fileopener" do

    it "opens file and appends data to array" do
      data = @x.fileopener("files/comma.txt")
      expect(data.empty?).to be_false
    end

    it "displays error message if there is no file" do
      expect(@x.fileopener("files/no_file.txt")).to eq("File does not exist")
    end

    it "detects if an uploaded file is a csv" do
      result = @x.detect_file_type("files/comma.txt")
      expect(result).to eq("csv")
    end

    it "detects if an uploaded file is a psv" do
      result = @x.detect_file_type("files/pipe.txt")
      expect(result).to eq("psv")
    end

    it "detects if an uploaded file is a ssv" do
      result = @x.detect_file_type("files/space.txt")
      expect(result).to eq("ssv")
    end

  end

  context "psv data modifier" do

    it "eliminates the middle initial from psv data" do
      data = @x.fileopener("files/pipe.txt")
      data[0] = @x.gender_modifier(data[0])
      @x.midname_modifier(data[0])
      expect(data[0].length).to eq(5)
    end

    it "reformats the gender" do
      data = @x.fileopener("files/pipe.txt")
      @x.gender_modifier(data[0])
      expect(data[0].include?("Male")).to be_true
    end

    it "moves the date to the last position" do
      data = @x.fileopener("files/pipe.txt")
      @x.date_mover(data[0])
      expect(data[0][data[0].length-2]).to eq("3-3-1985")
    end

    it "reformats the date" do
      data = @x.fileopener("files/pipe.txt")
      @x.date_mover(data[0])
      @x.date_modifier(data[0])
      expect(data[0][data[0].length-2]).to eq("3/3/1985")
    end

    it "correctly formats the data for psv" do
      data = @x.fileopener("files/pipe.txt")
      @x.data_modifier(data)
      expect(data[0]).to eq(["Smith", "Steve", "Male", "3/3/1985", "Red"])
    end

  end

  context "ssv data modifier" do

    it "eliminates the middle initial from data" do
      data = @x.fileopener("files/space.txt")
      @x.midname_modifier(data[0])
      data[0] = @x.gender_modifier(data[0])
      expect(data[0].length).to eq(5)
    end

    it "reformats the gender" do
      data = @x.fileopener("files/pipe.txt")
      @x.gender_modifier(data[0])
      expect(data[0].include?("Male")).to be_true
    end

    it "moves the date to the last position" do
      data = @x.fileopener("files/space.txt")
      @x.date_mover(data[0])
      expect(data[0][(data[0].length)-2]).to eq("6-3-1975")
    end

    it "reformats the date" do
      data = @x.fileopener("files/space.txt")
      @x.date_mover(data[0])
      @x.date_modifier(data[0])
      expect(data[0][(data[0].length)-2]).to eq("6/3/1975")
    end

    it "correctly formats the data for ssv" do
      data = @x.fileopener("files/space.txt")
      @x.data_modifier(data)
      expect(data[0]).to eq(["Kournikova", "Anna", "Female", "6/3/1975", "Red"])
    end

  end

  context "csv data modifier" do

    it "eliminates the middle initial from data" do
      data = @x.fileopener("files/comma.txt")
      data[0] = @x.gender_modifier(data[0])
      @x.midname_modifier(data[0])
      expect(data[0].length).to eq(5)
    end

    it "reformats the gender" do
      data = @x.fileopener("files/comma.txt")
      @x.gender_modifier(data[0])
      expect(data[0].include?("Male")).to be_true
    end

    it "moves the date to the last position" do
      data = @x.fileopener("files/comma.txt")
      @x.date_mover(data[0])
      expect(data[0][data[0].length-2]).to eq("2/13/1943")
    end

    it "reformats the date" do
      data = @x.fileopener("files/comma.txt")
      @x.date_mover(data[0])
      @x.date_modifier(data[0])
      expect(data[0][data[0].length-2]).to eq("2/13/1943")
    end

    it "correctly formats the data for csv" do
      data = @x.fileopener("files/comma.txt")
      @x.data_modifier(data)
      expect(data[0]).to eq(["Abercrombie", "Neil", "Male",  "2/13/1943", "Tan"])
    end

  end

end
