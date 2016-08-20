p "USDANDO A PALAVRA PROCUURAAAAA NO LUGAR DE COMPRAR ALTERAR DEPOIISS"
require 'watir-webdriver'
require 'mechanize'
require 'net/http'
require 'io/console'
ale = Random.rand(9999)
agent = Mechanize.new
p "Robo Versão '4.0.0 - #{ale}'"
ale += 10
ale = "Xx##{ale}xXz"
if STDIN.respond_to?(:noecho)
  def get_password(prompt="Como você está?: ")
    print prompt
    STDIN.noecho(&:gets).chomp
  end
else
  def get_password(prompt="Como você está?: ")
    `read -s -p "#{prompt}" password; echo $password`.chomp
  end
end
teste = ale
while ale == teste		
	novo = "s"
	while novo == "s"
		puts "Qual palavra o Robo deve Buscar? Exemplo: Compro / Busco / Quero Comprar, etc..."
		palavra = gets.chomp
		puts "Qual página o Robo deve COMEÇAR? Obs: Escreva somente um número"
		inicio = gets.to_i
		puts "Qual página o Robo deve TERMINAR? Obs: Escreva somente um número"
		fim = gets.to_i
		final = (inicio)/2
		puts "Passe #{final} contas quando terminar escreva fim"
		contas = []
		while contas.last != "fim"
		  contas << gets.chomp
		end
		puts "Passe um Nome que sera usado.Ex: Ana, Paula, Tati..."
		nome = gets.chomp
		p "Passe um nome para o Arquivo de Texto"
		arquivo_nome = gets.chomp
		p "Passe a Data de Hoje."
		data = gets.chomp
		p "Escreva algum comentario sobre o mesmo."
		comentario = "Comentário: #{gets.chomp}"
		p "Deseja alterar algum dado acima?(s/n)"
		novo = gets.chomp
	end
	senha = "predo12345"
	p "O Robo vai fazer da Pagina #{inicio}, a #{fim} da Palavra #{palavra}"
	fim -= 1
	puts "Aguarde..."
	arquivo = File.new("#{arquivo_nome}.txt", "w")

	arquivo.puts comentario
	arquivo.puts data
	b = Watir::Browser.new :chrome
	erros = []
	while inicio > fim
		if contas.length == 0
			p "Acabaram as contas!"
			inicio = fim
		else
			contas.each do |conta|
				if inicio <= 0
					p "Inicio: #{inicio} Bugado!"
				else
					# aqui
					if conta == "fim"
						p "Pulando a Conta: #{conta}"
						inicio += 1
						contas.delete(conta)
					elsif conta == ""
						erros << "Conta: #{conta} em Branco!"
						p "Conta: #{conta} em Branco!"
						inicio += 1
						contas.delete(conta)
					else
						#fazer o login e o restante
						begin
							b.goto "https://www3.olx.com.br/account/do_logout"
							b.text_field(id: 'login_email').set conta #preencher
							b.text_field(id: 'login_password').set senha #preencher
							b.button(type: 'submit').click
							sleep 1
							p s = b.link(text: "Minha conta").present?
							if s == true
								erros << "Conta: #{conta} Bugada"
								linha1 = "#{conta} Bugada!"
								arquivo.puts linha1
								contas.delete(conta)
							else
								p "Login Feito com Sucesso! conta: #{conta}"
								begin
									b.link(:text =>"Chat").when_present.click
									sleep 3
									mensagens = b.divs(class: "chat-info-box").length
									linha = "#{conta} mandou #{mensagens} Mensagens"
									arquivo.puts linha
									if mensagens > 90
										linha = "Ops! #{conta} mandou #{mensagens} Mensagens"
										erros << linha
										arquivo.puts linha
										contas.delete(conta)
									else
										p "Chat Verificado!"
										b.link(:text =>"Meu cadastro").when_present.click
										sleep 1
										b.text_field(id: 'fullname').set nome
										b.text_field(id: 'nickname').set nome
										sleep 1
										b.button(id: 'bt_submit_userinfo').click
										begin
											p "Vou fazer a Pagina #{inicio} e com Conta: #{conta} da Palavra: #{palavra}"
											#p h =  "http://www.olx.com.br/brasil?o=#{inicio}&ot=1&q=#{palavra}"
											page = agent.get("http://www.olx.com.br/brasil?o=#{inicio}&ot=1&q=#{palavra}")
											page.links_with(:dom_class => "OLXad-list-link").each do |link|
												begin
													b.goto link.href
													if b.url == link.href
														sleep 1
														s = b.link(text: "Minha conta").visible?
														if s == true 
															sleep 1
															b.goto "https://www3.olx.com.br/account/do_logout"
															b.text_field(id: 'login_email').set conta #preencher
															b.text_field(id: 'login_password').set senha #preencher
															b.button(type: 'submit').click
															sleep 1
															b.goto link.href
															sleep 1
															b.button(text: "Iniciar chat").click
												  			sleep 1
												  			b.textarea(name: 'message').when_present.set "Oii, tudo bem? Vi que seu anúncio você está PROCURANDO algo... sabia que existe um site chamado WWW.PAGOATE.COM.BR que existe exatamente para isso? No www.pagoate.com.br você anuncia o que quer comprar GRATUITAMENTE e de um jeito MUITO fácil... em 30 segundos seu anúncio já vai estar no ar, e milhares de pessoas vão saber o que você quer comprar. Porque você não faz um teste? Faz o seguinte: Anuncia seu desejo de compra e depois me conta, pode ser? Me escreve pra falar o que achou, ta? Beijos, #{nome} www.pagoate.com.br" #preencher
												  			b.button(text: "Enviar").click
												  			sleep 2
														else
															b.button(text: "Iniciar chat").click
												  			sleep 1
												  			b.textarea(name: 'message').when_present.set "Oii, tudo bem? Vi que seu anúncio você está PROCURANDO algo... sabia que existe um site chamado WWW.PAGOATE.COM.BR que existe exatamente para isso? No www.pagoate.com.br você anuncia o que quer comprar GRATUITAMENTE e de um jeito MUITO fácil... em 30 segundos seu anúncio já vai estar no ar, e milhares de pessoas vão saber o que você quer comprar. Porque você não faz um teste? Faz o seguinte: Anuncia seu desejo de compra e depois me conta, pode ser? Me escreve pra falar o que achou, ta? Beijos, #{nome} www.pagoate.com.br" #preencher
												  			b.button(text: "Enviar").click
												  			sleep 2
														end #end do else da verificacao de login
													else
														p "Falha ao Abrir o link: #{h}"
														erros << "Falha ao Abrir o link: #{h}"
													end
												rescue
													p "Falha ao Abrir o Chat! palavra: #{palavra}"
													p chat = b.url
													erros << "Falha ao Abrir o Chat! palavra: #{palavra} link: #{chat}"
												end#end do chat
											end #end do each dos links mechanize
										rescue
											p "Falha ao Abrir os Links! palavra: #{palavra}"
											erros << "Falha ao Abrir os Links! palavra: #{palavra}"
										end #end do begin dos links mechanize
									end#end do else do chat
								rescue
									p "Falha ao Verificar o Chat!"
									erros << "Falha ao Verificar o Chat! conta: #{conta}"
								end #end da verificação do chat
							end# end do else verificando se a conta está bugada
						rescue
							p "Falha no Login!"
							erros << "Falha no Login! conta: #{conta}"
						end #end begin do login
					end# end da verificação da conta para login
				end
			linha = "Fiz a Pagina #{inicio} e usei a Conta #{conta} da Palavra: #{palavra}"
			arquivo.puts linha
			inicio -= 1
			end#end each contas
		end		
	end#end do while
	arquivo.close
	arquivo1 = File.new("#{arquivo_nome}_erros.txt", "w")
	if erros.length == 0
		erro = "Não Ocorreu nenhum erro! =D"
		arquivo1.puts erro
	else 
		arquivo1.puts "#{erros.length} - Erro(s)"
		erros.each do |erro|
			p erro
			arquivo1.puts erro		
		end
	end
	arquivo1.close
	b.close
end
if ale == teste
	p "Fim!"
else
	while 1 > 0
		p "Que Bom!"
	end
end
=begin
page = agent.get("http://pago-ate-staging.herokuapp.com/anuncios/compro-teste-proposta")
sleep 2
form = page.form_with(id: "mbr-login-form")
form['contact[name]'] = "Robô"
form['contact[email]'] = "no-reply@example.com"
form['contact[phone]'] = "(11) 1 1111-1111"
form['contact[message]'] = "#{ale}"
form.submit
=end