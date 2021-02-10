function status = testBusHeader()

    status = true;
    fileName = 'testBus.h';

    created = makeBusses(fileName);
    busNames = fieldnames(created);

    % Dont reomve this nust clear busses if already existing in base workspace
    evalin('base',['clear ' strjoin(busNames,' ')])

    % Make the bus header from the bus objects
    for n = 1 : numel(busNames)
        busName = busNames{n};
        busToHeader(created.(busName), fileName, busName, []);
    end
    sortBusHeader(fileName);

    % This imports each bus into base workspace, if any import fails test will
    % error. If any import is malformed test will dectect this.
    Simulink.importExternalCTypes(fileName);

    for n = 1 : numel(busNames)
        busName = busNames{n};
        imported.(busName) = evalin('base',busName);
    end

    for n = 1 : numel(busNames)
        busName = busNames{n};
        check = isequal(imported.(busName), created.(busName));
        fprintf('Checking %s import and export match: %d\n', busName, check);
        status = status | check;
    end

end

function busses = makeBusses(fileName)

    SFB_LIMITBUS_ELEMENTS(2) = Simulink.BusElement();
    SFB_SIGNALBUS_ELEMENTS(1) = Simulink.BusElement();
    SFB_COUNTERBUS_ELEMENTS(2) = Simulink.BusElement();

    SFB_SIGNALBUS = Simulink.Bus();
    SFB_LIMITBUS = Simulink.Bus();
    SFB_COUNTERBUS = Simulink.Bus();

    SFB_SIGNALBUS.HeaderFile = fileName;
    SFB_LIMITBUS.HeaderFile = fileName;
    SFB_COUNTERBUS.HeaderFile = fileName;
    SFB_SIGNALBUS.DataScope = 'Imported';
    SFB_LIMITBUS.DataScope = 'Imported';
    SFB_COUNTERBUS.DataScope = 'Imported';

    SFB_LIMITBUS_ELEMENTS(1).Name = 'upper_saturation_limit';
    SFB_LIMITBUS_ELEMENTS(2).Name = 'lower_saturation_limit';

    SFB_LIMITBUS_ELEMENTS(1).DataType = 'int32';
    SFB_LIMITBUS_ELEMENTS(2).DataType = 'int32';

    SFB_SIGNALBUS_ELEMENTS(1).Name = 'input';
    SFB_SIGNALBUS_ELEMENTS(1).DataType = 'int32';

    SFB_COUNTERBUS_ELEMENTS(1).Name = 'inputsignal';
    SFB_COUNTERBUS_ELEMENTS(2).Name = 'limits';
    SFB_COUNTERBUS_ELEMENTS(1).DataType = 'Bus: SFB_SIGNALBUS';
    SFB_COUNTERBUS_ELEMENTS(2).DataType = 'Bus: SFB_LIMITBUS';

    SFB_SIGNALBUS.Elements = SFB_SIGNALBUS_ELEMENTS;
    SFB_LIMITBUS.Elements = SFB_LIMITBUS_ELEMENTS;
    SFB_COUNTERBUS.Elements = SFB_COUNTERBUS_ELEMENTS;
    
    busses.SFB_SIGNALBUS = SFB_SIGNALBUS;
    busses.SFB_LIMITBUS = SFB_LIMITBUS;
    busses.SFB_COUNTERBUS = SFB_COUNTERBUS;
    busses.SFB_COUNTER = SFB_COUNTERBUS;
    
end