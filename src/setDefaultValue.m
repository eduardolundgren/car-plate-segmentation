function setDefaultValue(position, argName, defaultValue)

if evalin('caller', 'nargin') < position || ...
		isempty(evalin('caller', argName))
	assignin('caller', argName, defaultValue);
end
end