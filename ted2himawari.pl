=pod
    Copyright (C) 2020 Masaya YAMAGUCHI

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
=cut

#
# ted2himawari.pl ver.20200804
#
# Usage: perl ted2himawari.pl ted_lang1.xml ted_lang2.xml > corpus.xml
#
# Written by Masaya YAMAGUCHI

use strict;
use utf8;
use XML::LibXML;
use Encode qw/encode decode/;

binmode STDIN, ':utf8';
binmode STDOUT, ':raw:encoding(UTF-16LE)';
#binmode STDOUT, ':utf8';
binmode STDERR, ':utf8';

die "Usage: perl ted2himawawri.pl ted_lang1.xml ted_lang2.xml" if(@ARGV) != 2;

my %result_talks = ();

# open a key xml file
my $key_xmlfile_name = shift(@ARGV);
my $parser = XML::LibXML->new;

my $key_language = readArchive($key_xmlfile_name);
my @target_languages = ($key_language);

foreach my $xmlfile_name (@ARGV){
    push(@target_languages, readArchive($xmlfile_name));
}

my $doc = XML::LibXML::Document->new('1.0','utf-16');
my $element_ted = $doc->createElement("ted");
$doc->setDocumentElement($element_ted);

my $target_language = $target_languages[1];
foreach my $talk_id (sort {$a <=> $b} keys %result_talks){
    # talk
    my $element_talk = $doc->createElement("talk");
    my $embed_url = $result_talks{$talk_id}{"url"}{$key_language};
    $embed_url =~ s/http.?:\/\/www\.ted\.com/https:\/\/embed\.ted\.com/;
	
    $element_talk->setAttribute("id", $talk_id);
    $element_talk->setAttribute("title", $result_talks{$talk_id}{"title"}{$key_language});
    $element_talk->setAttribute("url", $result_talks{$talk_id}{"url"}{$key_language});
    $element_talk->setAttribute("embed_url", $embed_url);
    $element_talk->setAttribute("speaker", $result_talks{$talk_id}{"speaker"}{$key_language});
    $element_ted->appendChild($element_talk);
    $element_ted->appendText("\n");

    # description
    my $element_description = $doc->createElement("description");
    $element_description->appendText($result_talks{$talk_id}{"description"}{$key_language});
    $element_talk->appendChild($element_description);
    $element_talk->appendText("\n");

    # transcription
    my $element_transcription = $doc->createElement("transcription");
    $element_talk->appendChild($element_transcription);
    $element_talk->appendText("\n");

    my @time_line = sort {$a <=> $b} keys %{$result_talks{$talk_id}{"trans"}};
    my $nTimes = scalar(@time_line);
    my $i = 0;
    while($i < $nTimes){
	my $time = $time_line[$i];
	my $text = "";
	my $key_text = $result_talks{$talk_id}{"trans"}{$time}{$key_language};
	my $target_text = $result_talks{$talk_id}{"trans"}{$time}{$target_language};
	if(defined($key_text)){
	    my $element_line = $doc->createElement("line");
	    $element_line->setAttribute("time", $time);
	    $element_line->setAttribute("formatted_time", formatTime($time));
	    $element_transcription->appendChild($element_line);
	    $element_transcription->appendText("\n");
	    $element_line->appendText($key_text);

	    $element_line
		->setAttribute("lang2", 
			       getTranscription($talk_id, $target_language, \@time_line, $i));

	    if(defined($target_text)){
		$element_line
		    ->setAttribute("eq_lang", $target_text);
	    }
	} else {
	    my $element_hidden_line = $doc->createElement("hidden_line");
	    $element_hidden_line->setAttribute("text", $target_text);
	    $element_transcription->appendChild($element_hidden_line);
	    $element_transcription->appendText("\n");
	}
	$i++;
    }


    $element_description->appendText($result_talks{$talk_id}{"description"}{$key_language});
    $element_talk->appendChild($element_description);

}

print pack("U", 0xFEFF); # byte order mark
print decode('utf-16', $doc->toString(0));



sub readArchive {
    my($xmlfile_name) = @_;

    my $doc = $parser->parse_file($xmlfile_name) 
	or die "Error: can't parse the file: $@";

    my $doc_root  = $doc->getDocumentElement();
    my @file_nodes = $doc_root->getElementsByTagName("file");
    my $language = $doc_root->getAttribute("language");
    
    my @talk_attribute_names = ("url", "speaker", "title", "description");
    
    foreach my $file_node (@file_nodes){     
	my $talk_id = getElementText($file_node, "talkid");
	if($key_language ne "" &&
	   $language ne $key_language &&
	   !defined($result_talks{$talk_id})){
#	    print STDERR "Warning: there is no transcription ($key_language) of the talk($talk_id, $language).\n";
	    next;
	}
	foreach my $attribute (@talk_attribute_names){
	    $result_talks{$talk_id}{$attribute}{$language} = getElementText($file_node, $attribute);
	}
	my @seekvideos = $file_node->getElementsByTagName("seekvideo");
	foreach my $seekvideo (@seekvideos){
	    my $time = $seekvideo->getAttribute("id");
	    $result_talks{$talk_id}{"trans"}{$time}{$language} = getText($seekvideo);
	}
    }

    return $language;
}

sub getElementText {
    my($root_node, $element_name) = @_;
    my ($element) = $root_node->getElementsByTagName($element_name);
    return getText($element);
}


sub getText {
    my($element) = @_;

    my $result_text = "";
    for my $child ($element->getChildNodes()) {
	# assume that $child is an element node 
	$result_text .= $child->getData();
    }
    return $result_text;
}

sub formatTime {
    my($time) = @_;
    my $min = int($time / 60000);
    my $sec = int(($time % 60000) / 1000);
    
    return sprintf("%02d:%02d", $min, $sec);
}


sub getTranscription {
    my($talk_id, $language, $ref_time_line, $index) = @_;
    
    my $target_text = $result_talks{$talk_id}{"trans"}{@{$ref_time_line}[$index]}{$language};
    my @result_texts = ();

    if(defined($target_text)){
	push(@result_texts, $target_text);
#	if($target_text =~ /^[A-Z]/ && $target_text =~ /\./){
#	    return $target_text;
#	} else {
#	    push(@result_texts, $target_text);
#	}
    }

    my $i = $index - 1;
    while($i >= 0){
	my $prev_text = $result_talks{$talk_id}{"trans"}{@{$ref_time_line}[$i]}{$language};
	if(defined($prev_text)){
	    unshift(@result_texts, $prev_text);
	    last;
	}
	$i--;
    }

    $i = $index + 1;
    while($i < scalar(@{$ref_time_line})){
	my $next_text = $result_talks{$talk_id}{"trans"}{@{$ref_time_line}[$i]}{$language};
	if(defined($next_text)){
	    push(@result_texts, $next_text);
	    last;
	}
	$i++;
    }
    return join(" /// ", @result_texts);
}
