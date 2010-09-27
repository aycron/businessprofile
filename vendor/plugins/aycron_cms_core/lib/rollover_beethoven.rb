if ROLLOVER_BEETHOVEN_ACTIVE
  
  module RolloverBeethoven
  
  # RolloverBeethoven
  
  private
  
=begin
    
    Rollovers... Spooty text-color rollovers, rendered as double width CSS-able images.
  
    options to pass on a fairly regular basis, may be set as presets
    --------------------------------------------------------------------
    :text => text to render into rollover graphic
    :id => will overide autogenned id
    :bg_color => background colour of entire image
    :fg_color => foreground colour of text
    :rollover_color => color of rolled-over text
    :rollover_bg_color => bg of rolled-over text
    :align => left or right
    :width => width of image, as displayed. Internally it will be twice as wide.
    :height => size of image, as displayed -- unless multiline, in which height is multiplied
    :font_size
    :x_offset
    :type => which set of settings.... err.... presets.... to use. See below.
    :rollover_active
    :link => url to link to
    :js => extra attributes, generally javascript
    :line_spacing
    :word_spacing      requires :method => :rvg
    :letter_spacing    requires :method => :rvg
    :format (defaults to gif)
    
    options which may occasionally come in handy, should have reasonable defaults
    ----------------------------------------------------------------------------------
    :split_at => word break point for multiline text... this could be done better, w/metrics...
    :class => class to add to the default 'bthvn'
    :method => :annotate or :rvg, defaults to :annotate
  
    config options....
    ----------------------------------------------------------------------------------
    :font_path => TTF font to use, stored in path...
    :file_path => path to generated file as based on RAILS_ROOT/public... i.e. 'images/auto/'
  
    
    aycron options...
    ---------------------------------------------------------------------------------------
    :float => left o right -> Div Float.
    :underline => true o false. Default false.
    :element_id => element's id attribute. Usefull for javascript manipulation.
  
  
  
=end
  
  require 'rvg/rvg'
  include Magick
  
  def font_path
    "#{RAILS_ROOT}/fonts"
  end
  
  def font_path_rvg # RVG already builds in the root it would seem... 1 hour of my life I will never get back
    "fonts"
  end
  
  def _split_text opts
  
    return [' '] if opts[:text].nil? || opts[:text]=='' # prevent 'no text' crash
  
    lines = Array.new
  
    if opts[:no_split]
      lines << opts[:text]
    else
      max_width = opts[:width].to_i
      text = opts[:text]
      text.gsub!(/\//,"/ ")
      
    # this code sucks
      # hm. this code here still sucks.
      words = text.split(' ')
      # words = text.split(' ')
      return [text] if words.empty?
      line_start = line_end = 0
      while true do
        trial_width = _get_text_width(opts.merge( :text => words[line_start..line_end].join(' ') ) )
        if trial_width <= max_width
          opts[:text_width]=trial_width if trial_width>opts[:text_width]
          line_end += 1
            else
          if line_end == 0 # // rut roh, this just don't fit! cram er in...
            # logger.info("JMS: Rollover No-fit -- cramming")   
            lines << words.join(' ')
            return lines
          end
          line_end -= 1;
          lines << words[line_start..line_end].join(' ')
          
          
          line_start = line_end = line_end + 1
        end
        if line_start >= words.length || line_end >= words.length
          lines << words[line_start..line_end].join(' ')
          return lines
        end
      end
    end
    logger.info("JMS: #{lines.inspect}")
    lines
  end
  
  def _get_text_width opts
    drawable = Magick::Draw.new
    drawable.pointsize = opts[:font_size]
    drawable.font = "#{font_path}/#{opts[:font]}"
    drawable.text_antialias = true
    if opts[:text].nil? || opts[:text]==''
      return 0
    else
      sludge = (opts[:line_padding]) ? opts[:line_padding].to_i : 0 # UGLY!! OMG!!!!
      drawable.get_type_metrics(opts[:text]).width.to_i + sludge
    end
  end
  
  def _check_cache opts
    
    settings = Hash.new
    settings[:defaults] = { :align => :left, :width => 160, :height => 20,
                            :split_at => 99, :x_offset => 0,
                            :rollover_active => false,
                            :word_spacing => 0, :line_spacing => 0, :letter_spacing => 0,
                            :font_size => 16,
                            :font_weight => 'normal',
                            :bg_color => '#000000',
                            :fg_color => '#AAAAAA',
                            :rollover_color => '#FFFFFF',
                            :method => :annotate,
                            :extra_width => 0,
                            :format => 'gif',
                            :file_path => "images/auto",
                            :images_prefix => nil,
                            :web_root => '',
                            :text_width => 0, # this is an *** output *** value
                            :float => :left,
                            :underline => false
                             }
  
     
    # and with a little luck, the rest of the file should be portable...  
    opts = settings[opts[:type]].merge!(opts) if opts.key?(:type)
    opts = settings[:defaults].merge!(opts)
  
    opts[:rollover_bg_color] ||= opts[:bg_color]
  
   # keepers = [:class,:call,:word_spacing,:letter_spacing,:font,:text,:bg_color,:fg_color,:rollover_color,:align,:width,:height,:font_size,:x_offset,:width,:height,:split_at,:extra_width,:extra_fg_code_pre,:extra_fg_code_post,:extra_bg_code_pre, :extra_bg_code_post]
   # opts_for_uid = opts.clone.delete_if{ |k,v| !keepers.include?(k) }
   # opts_for_uid = opts_for_uid.values.collect { |i| i.to_s }.sort
   # min_height, extra_final_code  
  
  
   # opts[:uid] = Zlib.crc32(Marshal.dump(opts_for_uid)).to_s
    opts_for_uid = opts.clone
    opts_for_uid[:uid] = nil
    opts[:uid] = Zlib.crc32(Marshal.dump(opts_for_uid)).to_s
  
  
    f = "#{opts[:file_path]}/#{opts[:uid]}.#{opts[:format]}"
    opts[:url] = "#{opts[:web_root]}/#{f}"
    opts[:image_url] = "#{opts[:images_prefix]}/#{f}"
    opts[:uid_fn] = "#{RAILS_ROOT}/public/#{f}"
    
  
    # check cache, return if it's there...
    # if true # !File.exists?(opts[:uid_fn])
    
    
    opts[:width] = _get_text_width(opts) + opts[:extra_width] if opts[:width]==:auto
    opts
    
  end
  
  def _draw_frame text,color,bg_color,opts,extra_code
    oversample = opts[:oversample] || 2
  
    case opts[:align]
      when :right
        anchor = 'end'
        x = opts[:width]+opts[:x_offset]
      when :left
        anchor = 'start'
        x = opts[:x_offset]
      when :center
        anchor = 'middle'
        x = opts[:width]/2
    end
  
    y_offs = (opts[:height] + (opts[:height]/2)) / 2
    h, w, fs = opts[:height],opts[:width],opts[:font_size]
    h *= oversample
    w *= oversample
    fs *= oversample
    x *= oversample
    y_offs *= oversample
    x_offs = opts[:x_offset] * oversample
    
    
    if opts[:method]==:rvg
      rvg = RVG.new(w,h) do |canvas|
        canvas.background_fill = bg_color
        canvas.text(x, y_offs) do |txt|
       # RVG wants the font path relative to RAILS_ROOT, while annotate seems to want the system path
     
          if opts[:underline]
            text_decoration = 'underline'
          end

          r = txt.tspan(text).styles(:text_anchor=>anchor, :font_size=>fs,   
             :font => "#{font_path_rvg}/#{opts[:font]}",
                :font_weight => opts[:font_weight],
                :fill => color,
                :letter_spacing => opts[:letter_spacing]*oversample,
                :word_spacing => opts[:word_spacing]*oversample,
                :text_decoration => text_decoration
              )  
        end 
      end
      img = rvg.draw
      img =  img.resize(opts[:width],opts[:height]) # returns image
      eval(extra_code) if extra_code
      return img
      
    end
   
    if opts[:method]==:annotate
      drawable = Magick::Draw.new
      drawable.pointsize = fs
      drawable.font = ("#{font_path}/#{opts[:font]}")
  #    drawable.font_weight = opts[:font_weight] if opts[:font_weight]
      case opts[:align]
      when :right
        drawable.gravity = Magick::EastGravity
      when :left
        drawable.gravity = Magick::WestGravity
      when :center
        drawable.gravity = Magick::CenterGravity
      end
      drawable.text_antialias = true

      if opts[:underline]
        drawable.decorate = Magick::UnderlineDecoration
      end
        
      drawable.fill = color
      img = ''
      if (opts[:bg_gradient_top] && opts[:bg_gradient_btm])
        gradient = GradientFill.new(0,0,w,0,opts[:bg_gradient_top],opts[:bg_gradient_btm])
        img = Magick::Image.new(w,h,gradient)
      else
        img = Magick::Image.new(w,h) {  self.background_color = bg_color }
      end
  
      drawable.annotate(img, 0, 0, x_offs, 0, text)
      eval(extra_code) if extra_code
    
      img = img.resize(opts[:width],opts[:height])
      return img.clone
    end
  end
  
  def make_image opts
      
    opts = _check_cache opts
   
    if !File.exists?(opts[:uid_fn])
      # logger.info "JMS:Starting Making Image : #{opts[:uid_fn]} and @use_cache == #{@use_cache.to_s}"
      vstack = ImageList.new
      hstack = ImageList.new
      
      lines = _split_text(opts)
      height_multiplier = lines.length
     # logger.info("JMS lines -- #{lines.inspect}")
      f = File.open(opts[:uid_fn]+'.l','w')
      f.puts height_multiplier.to_s
      f.puts opts[:text_width].to_s
      f.close
     
      lines.each do |line|
        hstack << _draw_frame(line,opts[:fg_color],opts[:bg_color],opts, opts[:extra_fg_code])
        if opts[:only_graph].nil?
          hstack << _draw_frame(line,opts[:rollover_color],opts[:rollover_bg_color],opts,opts[:extra_bg_code])
        end
        vstack << hstack.append(false)
        hstack.clear
      end
      final = vstack.append(true)
      if opts[:min_height]
        if final.rows < opts[:min_height]
          diff = opts[:min_height]-final.rows
          extra = Image.new(final.columns,diff/2) { self.background_color = opts[:bg_color] }
          vstack << extra.clone
          vstack.unshift(extra.clone)
          final = vstack.append(true)
        end
      end
      eval opts[:extra_final_code] if opts[:extra_final_code]
  
      final.format = opts[:format]
      final.write(opts[:uid_fn])
        # logger.info "JMS:Ending Making Image"
    else
      # logger.info "JMS:Starting Reading Spoot"
      f=File.open(opts[:uid_fn]+'.l','r')
      height_multiplier = f.gets.to_i
      opts[:text_width] =  f.gets.to_i
  #    logger.info("JMS: Getting Image from File... TextWidth=#{opts[:text_width]}")
  #    logger.info("File that was not found : #{opts[:uid_fn]}")
      f.close
       # logger.info "JMS:Finished Reading Spoot"
    end
    opts[:height_multiplier]=height_multiplier
    opts
  end
  
  
  def _rollover opts
    opts[:call] = 'rollover'
    opts = make_image opts
    height_multiplier=opts[:height_multiplier]
    
    cl = 'bthvn'
    opts[:css_id] = opts[:id] || "#{cl}#{opts[:uid]}"
     
    js = opts[:js] || ''
    link = opts[:link] 
     
    tag = 'a'
  
  
    style = "float:#{opts[:float]};"
    style += "background-image:url(#{opts[:url]});"
    style += "width:#{opts[:width]}px;"
    style += "height:#{(opts[:height]*height_multiplier).to_s}px;"
    if opts[:rollover_active] && opts[:rollover_active]==true
      bp = opts[:width]
      style += "background-position: -#{bp}px center;"
    else
      bp = 0
      style += "background-position: 0px center;"
    end
    if opts[:supress_behavior].nil?
      if opts[:inline]
        js += " onmouseover=\"this.style.backgroundPosition='-#{opts[:width]}px center'\""
        js += " onmouseout=\"this.style.backgroundPosition='#{bp}px center'\""
      else
        style += "} #{tag}:hover.#{opts[:css_id]}{"
        style += "background-position: -#{opts[:width]}px center;"
      end
    end
  
  
    if opts[:inline]
      style = " style=\"#{style}\" "  
    else     
      content_for('rollover_css') do
        o  = "#{tag}.#{opts[:css_id]} {"
        o += style
        o += "}"    
        o
      end
      style = ''
    end
    
    cl += " #{opts[:class]}" if opts[:class]
    target = (opts[:popup]) ? 'target="_new"' : ''
   
    if link.nil?
      link = '#'
      js = 'onclick="return false"' if js==''
    end
    opts[:tag] = "<a href=\"#{link}\" #{target} class=\"#{cl} #{opts[:css_id]}\" #{js} #{style}></a>"
    
    opts[:height] *= height_multiplier
    opts
  end
  
  def _graph_text opts
    opts[:call] = 'graph_text'
    opts = make_image opts
    height_multiplier=opts[:height_multiplier]
    
    cl = 'stat'
    opts[:css_id] = opts[:id] || "#{cl}#{opts[:uid]}"

    if opts[:element_id]
      id_attribute = "id=\"#{opts[:element_id]}\""
    else
      id_attribute = ''
    end
  
    tag = opts[:element] || 'div'
    style = "float:#{opts[:float]};"
   
    if opts[:omit_position]
      style += "background-image:url(#{opts[:url]});"
      style += "background-repeat:no-repeat;"
    else
      if opts[:images_prefix].nil?
        style += "background:url(#{opts[:url]}) no-repeat 0px center;"
      else
        style += "background:url(#{opts[:image_url]}) no-repeat 0px center;"
      end
    end
  
    style += "width:#{opts[:width]}px;" unless opts[:omit_width]
    style += "height:#{(opts[:height]*height_multiplier).to_s}px;" unless opts[:omit_height]
  
    if opts[:inline]
      style = " style=\"#{style}\" "  
    else
      content_for('rollover_css') do
        o  = "#{tag}.#{opts[:css_id]} {"
        o += style
        o += "}"
        o
      end
      style = ''
    end
    
    cl += " #{opts[:class]}" if opts[:class]
    filler = opts[:filler] || ''
    opts[:tag] = "<#{tag} #{id_attribute} class=\"#{cl} #{opts[:css_id]}\" #{opts[:js]} #{style}>#{filler}</#{tag}>"
    opts[:height] *= height_multiplier
    opts
  
  end
  
  public
  
  def graph_text opts, text = opts[:text]
    opts[:text] = text
    r = _graph_text opts
    r[:tag]
  end
  
  def graph_text_hash opts, text = opts[:text]
    opts[:text] = text
    r = _graph_text opts
    r
  end
  
  def rollover opts, text = opts[:text]
    opts[:text] = text
    r = _rollover opts
    r[:tag]
  end
  
  def rollover_hash opts, text = opts[:text]
    opts[:text] = text
    r = _rollover opts
    r
  end
  
  def get_img_src opts, text = opts[:text]
    opts[:text] = text
    opts[:only_graph] = true
    r = _graph_text opts
    r[:image_url]
  end
  
  
  end

end