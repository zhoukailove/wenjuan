# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.delete_all
User.create!(name:  "周凯",
             login_name: "zk",
             password:              "111"
             )
user = []
99.times do |n|
  name = Faker::Name.name
  login_name = "example#{n}"
  password = "111"
  user << [ name,
          login_name,
          password
   ]
end


User.transaction do

  begin
    User.import([:name,:login_name,:password],user)
  rescue => e
    puts "user报错信息:#{e}"
  end
end


@a = YAML.load_file('php_git_pull_date.yaml')
new_grade = []
@a.each do |key,val|
  new_grade << [val[:id]]
end

AnswerCommand.transaction do
  AnswerCommand.delete_all
puts new_grade
  begin
    AnswerCommand.import([:answer_id],new_grade) if new_grade
  rescue => e
    raise "AnswerCommand in rescue  error is:#{e}"
  end
end
