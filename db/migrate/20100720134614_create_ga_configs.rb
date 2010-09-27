class CreateGaConfigs < ActiveRecord::Migration
  def self.up
    create_table :ga_configs do |t|
      t.string :event
      t.integer :value
      t.text :description
    end
    
    GAConfig.new(
      :event => "twitter",
      :description => "Por click en el link a recomendar por Twitter.",  
      :value => 0
    ).save!
      
    GAConfig.new(
      :event => "facebook",
      :description => "Por click en el link a recomendar por Facebook.",
      :value => 0
    ).save!
    
    GAConfig.new(
      :event => "website",
      :description => "Por click en el link del sitio oficial.",
      :value => 0
    ).save!
    
    GAConfig.new(
      :event => "print",
      :description => "Por click para imprimir la página.",
      :value => 0
    ).save!
    
    GAConfig.new(
      :event => "send_by_mail",
      :description => "Por click en enviar por correo.",
      :value => 0
    ).save!
    
    GAConfig.new(
      :event => "tabs",
      :description => "Por click en cada uno de los tabs",
      :value => 0
    ).save!
    
    GAConfig.new(
      :event => "contact",
      :description => "Por click al enviar el formulario de contacto",
      :value => 0
    ).save!
    
    GAConfig.new(
      :event => "print_map",
      :description => "Por click en imprimir el mapa",
      :value => 0
    ).save!
    
    GAConfig.new(
      :event => "image_gallery",
      :description => "Por click al recorrer las imagenes",
      :value => 0
    ).save!
    
    GAConfig.new(
      :event => "phone",
      :description => "Por click al mostrar los teléfonos",
      :value => 0
    ).save!
  end

  def self.down
    drop_table :ga_configs
  end
end
