// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function showPreview() {
  params = Form.serialize( 'edit-form' )
  new Ajax.Updater(
    'in-content-preview',
    '/ajax/textile_preview',
    {asynchronous:true, method:'post', parameters:params}
  );
  $('in-content').style.display = 'none';
  $('in-content-preview').style.display = 'block'
  $('in-content-tab').className = 'inactive';
  $('in-content-preview-tab').className = 'active'
}

function showInput() {
  $('in-content').style.display = 'block';
  $('in-content-preview').style.display = 'none'
  $('in-content-tab').className = 'active';
  $('in-content-preview-tab').className = 'inactive'
}

function clean(id) {
  src = document.getElementById(id);
  if ( src && src.value && (src.value.indexOf('MsoNormal') != -1) ) {
    if ( confirm("You appear to be copying HTML created by MS Word. The HTML generated by Word can be pretty messy. Would you like us to try and tidy it up and convert it into the format used by TeamSquad?") ) {
      src.value = cleanHTML(src.value);
    }
  }
}

/*****************************************************************
 * Word HTML Cleaner
 * Copyright (C) 2005 Connor McKay
 * Modified by Stephen Latter 2006
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
*****************************************************************/

//remplacement characters
var rchars = [["ñ","ó", "ë", "í", "ì", "î", '†'], ["-", "-", "'", "'", '"', '"', ' ']];

//html entities translation array
var hents = new Array();
hents['°'] = '&iexcl;';
hents['¢'] = '&cent;';
hents['£'] = '&pound;';
hents['§'] = '&curren;';
hents['•'] = '&yen;';
hents['¶'] = '&brvbar;';
hents['ß'] = '&sect;';
hents['®'] = '&uml;';
hents['©'] = '&copy;';
hents['™'] = '&ordf;';
hents['´'] = '&laquo;';
hents['¨'] = '&not;';
hents['≠'] = '&shy;';
hents['Æ'] = '&reg;';
hents['Ø'] = '&macr;';
hents['∞'] = '&deg;';
hents['±'] = '&plusmn;';
hents['≤'] = '&sup2;';
hents['≥'] = '&sup3;';
hents['¥'] = '&acute;';
hents['µ'] = '&micro;';
hents['∂'] = '&para;';
hents['∑'] = '&middot;';
hents['∏'] = '&cedil;';
hents['π'] = '&sup1;';
hents['∫'] = '&ordm;';
hents['ª'] = '&raquo;';
hents['º'] = '&frac14;';
hents['Ω'] = '&frac12;';
hents['æ'] = '&frac34;';
hents['ø'] = '&iquest;';
hents['¿'] = '&Agrave;';
hents['¡'] = '&Aacute;';
hents['¬'] = '&Acirc;';
hents['√'] = '&Atilde;';
hents['ƒ'] = '&Auml;';
hents['≈'] = '&Aring;';
hents['∆'] = '&AElig;';
hents['«'] = '&Ccedil;';
hents['»'] = '&Egrave;';
hents['…'] = '&Eacute;';
hents[' '] = '&Ecirc;';
hents['À'] = '&Euml;';
hents['Ã'] = '&Igrave;';
hents['Õ'] = '&Iacute;';
hents['Œ'] = '&Icirc;';
hents['œ'] = '&Iuml;';
hents['–'] = '&ETH;';
hents['—'] = '&Ntilde;';
hents['“'] = '&Ograve;';
hents['”'] = '&Oacute;';
hents['‘'] = '&Ocirc;';
hents['’'] = '&Otilde;';
hents['÷'] = '&Ouml;';
hents['◊'] = '&times;';
hents['ÿ'] = '&Oslash;';
hents['Ÿ'] = '&Ugrave;';
hents['⁄'] = '&Uacute;';
hents['€'] = '&Ucirc;';
hents['‹'] = '&Uuml;';
hents['›'] = '&Yacute;';
hents['ﬁ'] = '&THORN;';
hents['ﬂ'] = '&szlig;';
hents['‡'] = '&agrave;';
hents['·'] = '&aacute;';
hents['‚'] = '&acirc;';
hents['„'] = '&atilde;';
hents['‰'] = '&auml;';
hents['Â'] = '&aring;';
hents['Ê'] = '&aelig;';
hents['Á'] = '&ccedil;';
hents['Ë'] = '&egrave;';
hents['È'] = '&eacute;';
hents['Í'] = '&ecirc;';
hents['Î'] = '&euml;';
hents['Ï'] = '&igrave;';
hents['Ì'] = '&iacute;';
hents['Ó'] = '&icirc;';
hents['Ô'] = '&iuml;';
hents[''] = '&eth;';
hents['Ò'] = '&ntilde;';
hents['Ú'] = '&ograve;';
hents['Û'] = '&oacute;';
hents['Ù'] = '&ocirc;';
hents['ı'] = '&otilde;';
hents['ˆ'] = '&ouml;';
hents['˜'] = '&divide;';
hents['¯'] = '&oslash;';
hents['˘'] = '&ugrave;';
hents['˙'] = '&uacute;';
hents['˚'] = '&ucirc;';
hents['¸'] = '&uuml;';
hents['˝'] = '&yacute;';
hents['˛'] = '&thorn;';
hents['ˇ'] = '&yuml;';
hents['"'] = '&quot;';
hents['<'] = '&lt;';
hents['>'] = '&gt;';

function cleanHTML(d)
{
  var i;
  var o = '';

  //allowed tags
  var tags = ['p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'h7', 'h8',
    'ul', 'ol', 'li', 'u', 'i', 'b', 'a', 'table', 'tr', 'th', 'td', 'img',
    'strong', 'b', 'em', 'i' ];

  //allowed atributes for tags
  var aattr = new Array();
  aattr['a'] = ['href', 'name'];
  aattr['table'] = ['border'];
  aattr['th'] = ['colspan', 'rowspan'];
  aattr['td'] = ['colspan', 'rowspan'];
  aattr['img'] = ['src', 'width', 'height', 'alt'];

  //tags who's content should be deleted
  var dctags = ['head'];

  //Quote characters
  var quotes = ["'", '"'];

  //tags which are displayed as a block
  var btags = ['p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'h7', 'h8', 'ul', 'ol',
    'table', 'tr', 'th', 'td'];

  //Replace explicit whitespace characters with normal spaces
  d = d.replace(/(&nbsp;)+/g, ' ');
  
//replace weird word characters
  for (i = 0; i < rchars[0].length; i++)
    d = d.replace(new RegExp(rchars[0][i], 'g'), rchars[1][i]);
  
  // Shunt all headings down one level if h1 found
  if ( d.indexOf('<h1>') != -1) {
    d = d.replace(/<h5>/g, '<h6>');
    d = d.replace(/<\/h5>/g, '</h6>');
    
    d = d.replace(/<h4>/g, '<h5>');
    d = d.replace(/<\/h4>/g, '</h5>');
    
    d = d.replace(/<h3>/g, '<h4>');
    d = d.replace(/<\/h3>/g, '</h4>');
    
    d = d.replace(/<h2>/g, '<h3>');
    d = d.replace(/<\/h2>/g, '</h3>');
    
    d = d.replace(/<h1>/g, '<h2>');
    d = d.replace(/<\/h1>/g, '</h2>');
  }
  
  //initialize flags
  //what the next character is expected to be
  var expected = '';
  //tag text
  var tag = '';
  //tag name
  var tagname = '';
  //what type of tag it is, start, end, or single
  var tagtype = 'start';
  //attribute text
  var attribute = '';
  //attribute name
  var attributen = '';
  //if the attribute has had an equals sign
  var attributeequals = false;
  //if attribute has quotes, and what they are
  var attributequotes = '';
  
  var c = '';
  var n = '';
    
  /*Parser format:
  The parser is divided into three parts:
  The first section is for when the current type of character is known
  The second is for when it is an unknown character in a tag
  The third is for anything outside of a tag
  */
  
  //editing pass
  for (i = 0; i < d.length; i++)
  {
    //current character
    c = getc(d,i);
    //next character
    n = getc(d,i+1);
    
    //***Section for when the current character is known
    
    //if the tagname is expected
    if (expected == 'tagname')
    {
      tagname += c;
      //lookahead for end of tag name
      if (n == ' ' || n == '>' || n == '/')
      {
        tag += tagname;
        expected = 'tag';
      }
    }
    //if an attribute name is expected
    else if (expected == 'attributen')
    {
      attributen += c;
      //lookahead for end of attribute name
      if (n == ' ' || n == '>' || n == '/' || n == '=')
      {
        attribute += attributen;
        //check to see if its an attribute without an assigned value
        //determines whether there is anything but spaces between the attribute name and the next equals sign
        if (endOfAttr(d, i))
        {
          //if the attribute is allowed, add it to the output
          if (ae(attributen, aattr[tagname]))
            tag += attribute;
          
          attribute = '';
          attributen = '';
          attributeequals = false;
          attributequotes = '';
        }
        expected = 'tag';
      }
    }
    //if an attribute value is expected
    else if (expected == 'attributev')
    {
      attribute += c;
      
      //lookahead for end of value
      if ((c == attributequotes) || ((n == ' ' || n == '/' || n == '>') && !attributequotes))
      {
        //if the attribute is allowed, add it to the output
        if (ae(attributen, aattr[tagname]))
          tag += attribute;
        
        attribute = '';
        attributen = '';
        attributeequals = false;
        attributequotes = '';
        
        expected = 'tag';
      }
    }
    
    //***Section for when the character is unknown but it is inside of a tag
    
    else if (expected == 'tag')
    {
      //if its a space
      if (c == ' ')
        tag += c;
      //if its a slash after the tagname, signalling a single tag.
      else if (c == '/' && tagname)
      {
        tag += c;
        tagtype = 'single';
      }
      //if its a slash before the tagname, signalling its an end tag
      else if (c == '/')
      {
        tag += c;
        tagtype = 'end';
      }
      //if its the end of a tag
      else if (c == '>')
      {
        tag += c;
        //if the tag is allowed, add it to the output
        if (ae(tagname, tags))
          o += tag;
        
        //if its a start tag
        if (tagtype == 'start')
        {
          //if the tag is supposed to have its contents deleted
          if (ae(tagname, dctags))
          {
            //if there is an end tag, skip to it in order to delete the tags contents
            if (-1 != (endpos = d.indexOf('</' + tagname, i)))
            {
              //have to make it one less because i gets incremented at the end of the loop
              i = endpos-1;
            }
            //if there isn't an end tag, then it was probably a non-compliant single tag
          }
        }
        
        tag = '';
        tagname = '';
        tagtype = 'start';
        expected = '';
      }
      //if its an attribute name
      else if (tagname && !attributen)
      {
        attributen += c;
        expected = 'attributen';
        //lookahead for end of attribute name, in case its a one character attribute name
        if (n == ' ' || n == '>' || n == '/' || n == '=')
        {
          attribute += attributen;
          //check to see if its an attribute without an assigned value
          //determines whether there is anything but spaces between the attribute name and the next equals sign
          if (endOfAttr(d,i))
          {
            //if the attribute is allowed, add it to the output
            if (ae(attributen, attributen))
              tag += attribute;
            
            attribute = '';
            attributen = '';
            attributeequals = false;
            attributequotes = '';
          }
          expected = 'tag';
        }
      }
      //if its a start quote for an attribute value
      else if (ae(c, quotes) && attributeequals)
      {
        attribute += c;
        attributequotes = c;
        expected = 'attributev';
      }
      //if its an attribute value
      else if (attributeequals)
      {
        attribute += c;
        expected = 'attributev';
        
        //lookahead for end of value, in case its only one character
        if ((c == attributequotes) || ((n == ' ' || n == '/' || n == '>') && !attributequotes))
        {
          //if the attribute is allowed, add it to the output
          if (ae(attributen, attributen))
            tag += attribute;
          
          attribute = '';
          attributen = '';
          attributeequals = false;
          attributequotes = '';
          
          expected = 'tag';
        }
      }
      //if its an attribute equals
      else if (c == '=' && attributen)
      {
        attribute += c;
        attributeequals = true;
      }
      //if its the tagname
      else
      {
        tagname += c;
        expected = 'tagname';
        
        //lookahead for end of tag name, in case its a one character tag name
        if (n == ' ' || n == '>' || n == '/')
        {
          tag += tagname;
          expected = 'tag';
        }
      }
    }
    //if nothing is expected
    else
    {
      //if its the start of a tag
      if (c == '<')
      {
        tag = c;
        expected = 'tag';
      }
      //anything else
      else
      {
        o += htmlentities(c);
      }
    }
  }
  
  //beautifying regexs
  //remove duplicate spaces
  o = o.replace(/\s+/g, ' ');
  //remove unneeded spaces in tags
  o = o.replace(/\s>/g, '>');
  
  //remove empty tags
  //this loops until there is no change from running the regex
  var oo = o;
  while ((o = o.replace(/\s?<(.*)>\s*<\/\1>/g, '')) != oo)
    oo = o;
  //make block tags regex string
  var btagss = btags.join('|');
  //add newlines after block tags
  o = o.replace(new RegExp("\\s?</(" + btagss+ ")>", 'gi'), "</$1>\n");
  //remove spaces before block tags
  o = o.replace(new RegExp("\\s<(" + btagss + ")", 'gi'), "<$1");

  
  //fix lists
  o = o.replace(/((<p.*>\s*(&middot;|&#9642;) .*<\/p.*>\n)+)/gi, "<ul>\n$1</ul>\n");//make ul for dot lists
  o = o.replace(/((<p.*>\s*\d+\S*\. .*<\/p.*>\n)+)/gi, "<ol>\n$1</ol>\n");//make ol for numerical lists
  o = o.replace(/((<p.*>\s*[a-z]+\S*\. .*<\/p.*>\n)+)/gi, "<ol style=\"list-style-type: lower-latin;\">\n$1</ol>\n");//make ol for latin lists
  o = o.replace(/<p(.*)>\s*(&middot;|&#9642;|\d+(\S*)\.|[a-z]+\S*\.) (.*)<\/p(.*)>\n/gi, "\t<li$1>$3$4</li$5>\n");//make li
  
  //extend outer lists around the nesting lists
  o = o.replace(/<\/(ul|ol|ol style="list-style-type: lower-latin;")>\n(<(?:ul|ol|ol style="list-style-type: lower-latin;")>[\s\S]*<\/(?:ul|ol|ol style="list-style-type: lower-latin;")>)\n(?!<(ul|ol|ol style="list-style-type: lower-latin;")>)/g, "</$1>\n$2\n<$1>\n</$1>\n");
  
  //nesting lists
  o = o.replace(/<\/li>\s+<\/ol>\s+<ul>([\s\S]*?)<\/ul>\s+<ol>/g, "\n<ul>$1</ul></li>");//ul in ol
  o = o.replace(/<\/li>\s+<\/ol>\s+<ol style="list-style-type: lower-latin;">([\s\S]*?)<\/ol>\s+<ol>/g, "\n<ol style=\"list-style-type: lower-latin;\">$1</ol></li>");//latin in ol
  o = o.replace(/<\/li>\s+<\/ul>\s+<ol>([\s\S]*?)<\/ol>\s+<ul>/g, "\n<ol>$1</ol></li>");//ol in ul
  o = o.replace(/<\/li>\s+<\/ul>\s+<ol style="list-style-type: lower-latin;">([\s\S]*?)<\/ol>\s+<ul>/g, "\n<ol style=\"list-style-type: lower-latin;\">$1</ol></li>");//latin in ul
  o = o.replace(/<\/li>\s+<\/ol>\s+<ol style="list-style-type: lower-latin;">([\s\S]*?)<\/ol>\s+<ol>/g, "\n<ol style=\"list-style-type: lower-latin;\">$1</ol></li>");//ul in latin
  o = o.replace(/<\/li>\s+<\/ul>\s+<ol style="list-style-type: lower-latin;">([\s\S]*?)<\/ol>\s+<ul>/g, "\n<ol style=\"list-style-type: lower-latin;\">$1</ol></li>");//ul in latin
  //remove empty tags. this is needed a second time to delete empty lists that were created to fix nesting, but weren't needed
  o = o.replace(/\s?<(.*)>\s*<\/\1>/g, '');
  
  
  // Convert to textile
  o = o.replace(/<h2>(.*?)<\/h2>/gi, 'h2. $1\n');
  o = o.replace(/<h3>(.*?)<\/h3>/gi, 'h3. $1\n');
  o = o.replace(/<h4>(.*?)<\/h4>/gi, 'h4. $1\n');
  o = o.replace(/<h5>(.*?)<\/h5>/gi, 'h5. $1\n');
  o = o.replace(/<h6>(.*?)<\/h6>/gi, 'h6. $1\n');
  
  o = o.replace(/<p>(.*?)<\/p>/gi, '$1\n');
  o = o.replace(/<strong>(.*?)<\/strong>/gi, '*$1*');
  o = o.replace(/<b>(.*?)<\/b>/gi, '*$1*');
  o = o.replace(/<em>(.*?)<\/em>/gi, '_$1_');
  o = o.replace(/<i>(.*?)<\/i>/gi, '_$1_');
  
  return o;
}

//array equals
//loops through all the elements of an array to see if any of them equal the test.
function ae (needle, haystack)
{
  if (typeof(haystack) == 'object')
    for (var i = 0; i < haystack.length; i++)
      if (needle == haystack[i])
        return true;
  
  return false;
}

//get character
//return specified character from d
function getc(d,i)
{
  return d.charAt(i);
}

//end of attr
//determines if their is anything but spaces between the current character, and the next equals sign
function endOfAttr(d,i)
{
  var between = d.substring(i+1, d.indexOf('=', i+1));
  if (between.replace(/\s+/g, ''))
    return true;
  else
    return false;
}

function htmlentities(character)
{
  if (hents[character])
  {
    return hents[character];
  }
  else
  {
    return character;
  }
}