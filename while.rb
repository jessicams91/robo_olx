contas=["var0","var1","var2"]
contas.each do |conta|
	#p "Antes: #{contas}"
	if conta == "var1"
		conta = contas.index(conta)
		contas.delete_at(conta)
	else 
	end
	p "Depois: #{contas}"
end
p contas