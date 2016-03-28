require 'faker'
require 'csv'
#Class person
class Person
  attr_accessor :first_name, :last_name, :email, :phone, :created_at

  def initialize(firs_name, last_name, email, phone, created_at)
    @first_name = firs_name
    @last_name = last_name
    @email = email
    @phone = phone
    @created_at = created_at
  end

end
#Usar el faker para llenar las variables al azar
def create_person
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = Faker::Internet.email
    phone = Faker::PhoneNumber.phone_number
    created_at = Time.now
    #crear objetos personas con valores aleatorios del faker
    Person.new(first_name, last_name, email, phone, created_at)
end

 def number_persons(number)
  #crear array para meter personas
    array_persons = []
    for i in 1..number
      #meter personas el numero de veces que el usuario quiera
      array_persons << create_person
    end
    array_persons
  end


people = number_persons(20)
#p people[0].first_name

class PersonWriter
  def initialize(file, array)
    @file = file
    @array = array
  end
  #crear metodo para guardar los valores
  def create_csv
    #metodo csv que recorrera donde quieras debe tener el valor wb
    CSV.open(@file, "wb") do |csv|
      #iterar dentro del array para meter cada objeto persona por separado
      @array.each do |person|
        #Debe entrar el archivo en forma de array
        #para que pueda meter toda la informacion se debe separa con comas
        csv << [person.first_name, person.last_name, person.email, person.phone, person.created_at] #+ person.last_name 
      end
    end
  end
end
#Mostrara las personas en el archivo
class PersonParser
  #cada vez que se llame recibira un archivo con personas
  def initialize(personas)
    @personas = personas
    @people = []
  end
  #recorre en cada linea del archivo y las guarda en un array
  def people
    CSV.foreach(@personas) do |row|
      #Mete cada elemento a un array
      @people << Person.new(row[0],row[1],row[2],row[3],row[4])
    end
    #muestra los primeros 10
    # puts @people[0..9]
    #regresa el array lleno
    @people
  end
  #metodo para cambiar el nombre
  def change_name(name)
    #cambia el nombre de la persona en la posicion 0 por el que quieran
    people[0].first_name = name
    #llama a la clase personwriter y al metodo create_csv que modifica 
    #el archivo
    PersonWriter.new(@personas, people).create_csv
  end

end
#DRIVER CODE

person_writer = PersonWriter.new("people.csv", people)
person_writer.create_csv

parser = PersonParser.new('people.csv')
people = parser.people
parser.change_name("codeaboy")
