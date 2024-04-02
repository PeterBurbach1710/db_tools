a, b = 5, 10

function login()
  return "sys", "exasol"
end

username, password = login()


function login()
  return "sys", "exasol", "localhost"
end

-- ignore first return value
password, hostname = select(2, login())

print(username)
print(password)
print(hostname)

a, username, password, hostname = a, login()

