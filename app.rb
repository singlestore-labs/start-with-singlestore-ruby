require 'mysql2'

def main
  # TODO: pull from config
  client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "password_here", :database => "acme")

  id = create(client, 'Inserted row')
  puts "Inserted row #{id}"

  row = read_one(client, id);
  if (row)
    puts "Read row: #{row}"
  else
    puts "Read row: missing"
  end

  update(client, id, "Updated row")
  puts "Updated row id #{id}"
  
  rows = read_all(client)
  puts "Read all rows:"
  rows.each do |row|
    puts "  #{row}"
  end

  delete(client, id)
  puts "Deleted row id #{id}"

end

def create(client, content)
  stmt = client.prepare("INSERT INTO messages (content) VALUES (?)")
  stmt.execute(content)
  client.last_id
end

def read_one(client, id)
  stmt = client.prepare("SELECT id, content, createdate FROM messages WHERE id = ?")
  result = stmt.execute(id)
  result.first
end

def read_all(client)
  results = client.query("SELECT * FROM messages ORDER BY id")
  results
end

def update(client, id, content)
  stmt = client.prepare("UPDATE messages SET content = ? WHERE id = ?")
  stmt.execute(content, id)
end

def delete(client, id)
  stmt = client.prepare("DELETE FROM messages WHERE id = ?")
  stmt.execute(id)
end

if __FILE__ == $0
  main
end
