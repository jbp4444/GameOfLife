--
--   Copyright 2013 John Pormann
--

function safeRemoveSelf( o )
	--print( "removing object" )
	--print( o )
	o:removeSelf()
	o = nil
end

-- TODO: look at device name and provide good size for a basic button
function goodButtonSize()
	local w = display.contentWidth * 0.55
	local h = 70
	return w,h
end

function dprint( num, txt )
	-- how much printing do we want?
	if( num < debug_level ) then
		print( txt )
	end
end

function printtable(table, indent )
  indent = indent or 0;

	if( indent > 500 ) then
		return
	end
	
  print(string.rep('  ', indent)..'{');
  indent = indent + 1;
  for k, v in pairs(table) do

    local key = k;
    if (type(key) == 'string') then
      if not (string.match(key, '^[A-Za-z_][0-9A-Za-z_]*$')) then
        key = "['"..key.."']";
      end
    elseif (type(key) == 'number') then
      key = "["..key.."]";
    end

    if( key == '_class' ) then
        print( string.rep('  ', indent) .. "key="..tostring(key).." skipping" );
    elseif (type(v) == 'table') then
      if (next(v)) then
        print( string.rep('  ', indent) .. "key="..tostring(key));
        printtable(v, indent);
      else
        print( string.rep('  ', indent) .. "key="..tostring(key));
      end 
    elseif (type(v) == 'string') then
      print( string.rep('  ', indent) .. "key="..tostring(key) .. " val=['"..v.."']");
    else
      print( string.rep('  ', indent) .. "key="..tostring(key) .. " val=["..tostring(v).."]");
    end
  end
  indent = indent - 1;
  print(string.rep('  ', indent)..'}');
end
