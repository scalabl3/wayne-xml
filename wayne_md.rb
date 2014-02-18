require 'rubygems'
require 'json'
require 'map'
require 'yaml'
require 'chronic'
require 'nokogiri'
require 'redcarpet'
require './classes/markdown_render.rb'


Dir.chdir(".")
GROOT = Dir.pwd

content_root = "./docs/src"

Dir.chdir(content_root)
CROOT = Dir.pwd

CONTENT_LINK_PREFIX = "d"


#######################################################################
# Utility Methods
#######################################################################

def parse_markdown_file(filepath)
  metadata = nil
  markdown = nil

  mdfile = (filepath + ".markdown" unless filepath.end_with? (".markdown"))

  md = File.read(mdfile)
  if match = md.match(/(<meta>)([\S\s]+)(<\/meta>)/)
    x, metadata, y = match.captures
    metadata = YAML.load metadata
    markdown = md.gsub(/<meta>[\S\s]+<\/meta>/, "")
  else      
    markdown = md
  end
  
  return metadata, markdown
end

def node_has_children(node)
  if node.children? and node.children.count? and node.children.count > 0 and node.children.items? and node.children.items
    true
  else
    false
  end
end

#######################################################################
# Setup Content Hash and Content Root Folder
#######################################################################

def traverse_nav_tree_and_convert_to_xml(node)
    
  # traverse subfolders, go deep
  if node_has_children(node)
     node.children.items.each do |child|
       traverse_nav_tree_and_convert_to_xml(child)
     end
  end
  
  return if node.nav_level == 0
  
  mod = node.dup

  link = node.link
  full_link = node.full_link
  
  mod.parent_link = parent_link = node.link[0..(link.rindex("/") - 1)] if node.nav_level > 1
  
  if CONTENT_LINK_PREFIX && CONTENT_LINK_PREFIX.length > 0
    full_link = mod.full_link = "/" + CONTENT_LINK_PREFIX + node.full_link unless node.full_link.start_with?("/#{CONTENT_LINK_PREFIX}")
  end

  
  mod.delete :source_path
  mod.delete :parent_path
  mod.delete :children


  #puts "storing [#{mod.nav_level}][#{mod.nav_order}][#{mod.nav_type}] - #{mod.nav_title}"
  case mod.nav_type  
  
  when "folder"
		# do nothing for these
  when "markdown"
    metadata, markdown = parse_markdown_file(node.source_path)
		
		filepath_markdown = node.source_path.dup		
		filepath_markdown += ".markdown"	unless filepath_markdown.end_with? (".markdown")		
		mod.updated_at = Chronic.parse(File.mtime(filepath_markdown).to_s).utc.to_i
		
    mod.metadata = metadata if metadata
    mod.markdown = markdown
    
		html = MarkdownRender::render(mod.markdown)
		doc = Nokogiri::HTML(html) 
		xml = doc.css('body')[0].serialize #(save_with: 0)
		xml.gsub!(/^<p><img /, "<img ")
		xml = Nokogiri::XML(xml)
		b = xml.at_css "body"
		b.name = "doc"
		
    File.open("#{filepath_markdown.gsub(/.markdown/, ".xml")}", 'w') { |f| xml.write_xml_to f }

  when "folder+markdown"
    metadata, markdown = parse_markdown_file(node.source_path)
		
		filepath_markdown = node.source_path.dup		
		filepath_markdown += ".markdown"	unless filepath_markdown.end_with? (".markdown")		
		mod.updated_at = Chronic.parse(File.mtime(filepath_markdown).to_s).utc.to_i
		
    mod.metadata = metadata if metadata
    mod.markdown = markdown

		html = MarkdownRender::render(mod.markdown)
		doc = Nokogiri::HTML(html)
		xml = doc.css('body')[0].serialize #(save_with: 0)
		xml.gsub!(/^<p><img /, "<img ")
		xml = Nokogiri::XML(xml)

    img_sizes = {
      "40%" => "min",
      "50%" => "small",
      "65%" => "medium",
      "100%" => "full",
      "600px" => "large"
    }
    
    img_sizes.each do |size,name|
      img = xml.at_css "img[width=\"#{size}\"]"
      img['size'] = name if img
      puts img.inspect if img
    end

		b = xml.at_css "body"
		b.name = "doc"
		
    File.open("#{filepath_markdown.gsub(/.markdown/, ".xml")}", 'w') { |f| xml.write_xml_to f }
  end
  
end

def clean_up_hierarchy(node)
  # traverse subfolders, go deep
  if node_has_children(node)
     node.children.items.each do |child|
         items = clean_up_hierarchy(child)
     end
  end
  
  cleaned_nav_items = nil
  
  if node_has_children(node)
    cleaned_nav_items = node.children.items

    cleaned_nav_items.each do |n| 
      n.delete :source_path
      n.delete :parent_path
    end  
  end
  
  if node.full_link? && CONTENT_LINK_PREFIX && CONTENT_LINK_PREFIX.length > 0
    node.full_link = "/" + CONTENT_LINK_PREFIX + node.full_link unless node.full_link.start_with?("/#{CONTENT_LINK_PREFIX}")
  end
  
  cleaned_nav_items
end


def create_ordered_flattened_hierarchy(node)
  
  list = []
  node_orphan = node.dup
  node_orphan.delete(:children)  
  list << node_orphan
  
  if node_has_children(node)
    node.children.items.each do |child|
      child_list = create_ordered_flattened_hierarchy(child)
      child_list.each do |n|
        list << n
      end      
    end
  end
  
  return list
end


#######################################################################
# Load into Couchbase
#######################################################################


nav_tree = Map.new(YAML.load_file("#{GROOT}/tree/cbu_nav_tree.yml"))

traverse_nav_tree_and_convert_to_xml(nav_tree.nav)

hierarchy = { root: clean_up_hierarchy(nav_tree.nav) }

flat_arr = create_ordered_flattened_hierarchy(nav_tree.nav)
flat_arr.shift

flat_hierarchy = { list: flat_arr }

flat_hierarchy[:list].each do |n|
  puts "[#{n.nav_level}][#{n.nav_order}] - [#{n.link}]"
end

File.open("#{GROOT}/tree/cbu_nav_tree_flat.yml", 'w') { |file| file.write(flat_hierarchy.to_yaml) }

exit


