#!/usr/bin/env ruby

require 'rdf/turtle'
require 'pp'

graph = RDF::Graph.new do |g|
  RDF::Turtle::Reader.new(ARGF.read){|reader|
    g << reader
  }
end
query = RDF::Query.new({
  result: {
    RDF.type => RDF::URI("http://www.w3.org/ns/shacl#ValidationResult"),
    RDF::URI("http://www.w3.org/ns/shacl#focusNode") => :focus,
    RDF::URI("http://www.w3.org/ns/shacl#resultMessage") => :message,
    RDF::URI("http://www.w3.org/ns/shacl#resultPath") => :path,
    RDF::URI("http://www.w3.org/ns/shacl#resultSeverity") => :severity,
    RDF::URI("http://www.w3.org/ns/shacl#sourceConstraintComponent") => :constraint,
    RDF::URI("http://www.w3.org/ns/shacl#sourceShape") => :shape, 
    RDF::URI("http://www.w3.org/ns/shacl#value") => :value,
  }
})
query.execute(graph).each do |result|
  next if result.message.to_s =~ /\AValue does not have class cs:/
  pp result.to_h
end
