#Encoding: UTF-8 
#classe  UserController  <  ApplicationController
#encoding: UTF-8 
require 'watir-webdriver'
require 'mechanize'
novo = "s"
while novo == "s"
	page = 1
	page.to_i
	puts "Passe o link do Pago Ate!"
	link = gets.chomp
	puts "Qual página o Robo deve COMEÇAR? NO PAGO ATE Obs: Escreva somente um número"
	inicioP = gets.to_i
	b = Watir::Browser.new  
	b.goto "#{link}?page=#{page}"
	sleep 1
	puts "Qual página o Robo deve COMEÇAR NA OLX? Obs: Escreva somente um número"
	inicio1 = gets.to_i
	puts "Qual página o Robo deve TERMINAR NA OLX? Obs: Escreva somente um número"
	fim1 = gets.to_i
	final = (inicioP *16)
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
fim1 -= 1
arquivo = File.new("#{arquivo_nome}.txt", "w")
buscas = []
while inicioP >=  page
	sleep 1
	p "Page: #{page}"
	b.goto "#{link}?page=#{page}"
	b.h2s(class: "u-linkInverse").each do |texto|
		#p texto.text
		palavras = texto.text.gsub("(","").gsub(")","").gsub("?","").gsub("-","").gsub("Compro ","").gsub("!","").gsub("Procuro ","").gsub("COMPRO ","").gsub("/ ","").gsub(".","").gsub(",","")
		p "Aqui: #{palavras}"
		buscas<<palavras		
	end
	page += 1
end
erros = []
b.close
sleep 1
agent = Mechanize.new
b = Watir::Browser.new  
feitas = []
p "Passando as Palavras"
buscas.each do |busca|
	p busca.split[0..2].join(" ")
	buscaD = busca.downcase
	if feitas.include?(buscaD)
		p "Já Foi Feita a Palavra: #{buscaD}"
	else
		p "Iniciando..."
		feitas << buscaD
		linkP = busca.split[0..2].join("+")
		inicio = inicio1
		fim = fim1
		while inicio > fim
			contas.each do |conta|
				if conta == "fim"
					p "Pulando a Conta: #{conta}"
					inicio += 1
					index = contas.index(conta)
					contas.delete_at(index)
				elsif conta == ""
					erros << "Conta: #{conta} em Branco!"
					p "Conta: #{conta} em Branco!"
					inicio += 1
					index = contas.index(conta)
					contas.delete_at(index)
				else
					#fazer o login e o restante
					begin
						b.goto "https://www3.olx.com.br/account/do_logout"
						b.text_field(id: 'login_email').set conta #preencher
						b.text_field(id: 'login_password').set senha #preencher
						b.button(type: 'submit').click
						sleep 1
						s = b.link(text: "Minha conta").visible?
						if s == true
							erros << "Conta: #{conta} Bugada"
							linha1 = "#{conta} Bugada!"
							arquivo.puts linha1
							index = contas.index(conta)
							contas.delete_at(index)
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
									index = contas.index(conta)
									contas.delete_at(index)
								else
									p "Chat Verificado!"
									b.link(:text =>"Meu cadastro").when_present.click
									sleep 1
									b.text_field(id: 'fullname').set nome
									b.text_field(id: 'nickname').set nome
									sleep 1
									b.button(id: 'bt_submit_userinfo').click
									begin
										if inicio <= 0
											p "Inicio: #{inicio} Bugado!"
										else
											#aqui
											p h =  "http://www.olx.com.br/brasil?o=#{inicio}&ot=1&q=#{linkP}"
											p "Vou fazer a Pagina #{inicio} e com Conta: #{conta} da buscaD = busca: #{busca}"
											page = agent.get("http://www.olx.com.br/brasil?o=#{inicio}&ot=1&q=#{linkP}")
											page.links_with(:dom_class => "OLXad-list-link").each do |link|
												begin
													b.goto link.href
													sleep 1
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
														else
															b.button(text: "Iniciar chat").click
												  			sleep 1
												  			b.textarea(name: 'message').when_present.set "Olá! Se você deseja Vender seu #{busca}, o comprador certo para você esta no Pago Até. Milhares de pessoas já compraram anunciando no www.Pagoate.com.br .Por que você não faz um teste? É fácil, rápido e GRÁTIS!  Veja agora mesmo compradores do seu produto: http://pagoate.com.br/busca?utf8=%E2%9C%93&order=created_at&state=Brasil&query=#{linkP}&button="  #preencher
												  			b.button(text: "Enviar").click
												  			sleep 2
														end #end do else da verificacao de login
													else
														p "Falha ao Abrir o link: #{h}"
														erros << "Falha ao Abrir o link: #{h}"
														inicio -= 1
													end#end dos termos do if para iniciar um chat
												rescue
													p "Falha ao Abrir o Chat! palavra: #{busca}"
													p chat = b.url
													erros << "Falha ao Abrir o Chat! palavra: #{busca} link: #{chat}"
												end#end do chat
											end #end do each dos links mechanize
										end#end if / else do inicio
									rescue
										p "Falha ao Abrir os Links! palavra: #{busca}"
										erros << "Falha ao Abrir os Links! palavra: #{busca}"
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
				index = contas.index(conta)
				contas.delete_at(index)
				linha = "Fiz a Pagina #{inicio} e usei a Conta #{conta} da Palavra: #{busca}"
				arquivo.puts linha
				inicio -= 1
			end#end each contas
		end#end do while
	end #end do if / else da verificacao da buscaD
end
arquivo.close
arquivo1 = File.new("#{arquivo_nome}_erros.txt", "w")
tem = erros.length
if tem == 0
	erro = "Não Ocorreu nenhum erro! =D"
	arquivo1.puts erro
else 
	erros.each do |erro|
		arquivo1.puts erro		
	end
end
arquivo1.close
b.close