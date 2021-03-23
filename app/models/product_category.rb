class ProductCategory < ApplicationRecord
  validates :name, :code, presence: {message: 'Não pode ficar em branco'}, 
                          uniqueness: { message: 'deve ser único'}

  

end
