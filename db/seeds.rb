puts "Limpando banco de dados..."
Consent.destroy_all
User.destroy_all
Purpose.destroy_all

puts "Criando usuário de teste..."
user = User.create!(
  name: "Usuário de Teste",
  email: "teste@exemplo.com"
)

puts "Criando finalidades..."
marketing = Purpose.create!(name: "Receber comunicações de marketing")
analytics = Purpose.create!(name: "Uso de dados para analytics")
newsletter = Purpose.create!(name: "Inscrição em newsletter")

puts "Criando um consentimento inicial (exemplo)..."
Consent.create!(
  user: user,
  purpose: marketing,
  status: :granted,
  granted_at: Time.current
)

puts "Seeds criadas com sucesso!"
puts "---------------------------"
puts "Usuário de teste: #{user.email} (ID: #{user.id})"
puts "Acesse a tela de gerenciamento em: http://localhost:3000/users/#{user.id}"