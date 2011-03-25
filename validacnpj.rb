# valida cnpj 
#

# Require das gems
['sinatra','haml'].each { |x| require x }

get '/' do
  haml :index
end

post '/valida' do
  valida_cnpj(params[:cnpj]) ? (haml :valido) : (haml :invalido)
end

# metodo que valida se um numero passado é um cnpj válido.
def valida_cnpj(x)
  if x.to_s.size == 14 
    cnpj = x.to_s.split(//)
    dv = calcula_digito(cnpj[0,12].join)
    dv.join == cnpj[12,2].join ? true : false
  else
    false
  end
end

def calcula_digito(x)
  dv1 = [5,4,3,2,9,8,7,6,5,4,3,2]
  dv2 = [6,5,4,3,2,9,8,7,6,5,4,3,2]
  dv = []
  # calc do primeiro digito do CNPJ
  soma = x.to_s.split(//)[0,12].map(&:to_i).inject(0) { |mem, n| mem + (n * dv1.shift) }
  dv[0] = (0..1).include?(soma % 11) ? 0 : (11 - (soma % 11))
  # calc do segundo digito do CNPJ
  soma = (x.to_s.split(//)[0,12] << dv[0]).map(&:to_i).inject(0) { |mem, n| mem + (n * dv2.shift) }
  dv[1] = (0..1).include?(soma % 11) ? 0 : (11 - (soma % 11))
  
  dv
end
