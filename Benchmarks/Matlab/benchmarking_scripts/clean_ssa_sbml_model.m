function [] = clean_ssa_sbml_model(model)
    parameters = sbioselect(model, 'Type', 'parameter');
    for paramIndex = 1:numel(parameters)
        parameter = parameters(paramIndex);
        [~, usageTable] = findUsages(parameter);
    
        % Update any reaction that uses this parameter in its rate.
        if isempty(usageTable)      % if check added by Torkel.
            continue
        end
        reactions = usageTable.Component(usageTable.Property == "ReactionRate");
        for reactionIndex = 1:numel(reactions)
            reaction = reactions(reactionIndex);
            oldRate = reaction.ReactionRate;
            kineticLaw = reaction.KineticLaw;
            if isempty(kineticLaw)
                % Add a kinetic law
                kineticLaw = addkineticlaw(reaction, 'MassAction');
            else
                % Update the existing kinetic law to mass action
                kineticLaw.KineticLawName = 'MassAction';
            end
            kineticLaw.ParameterVariableNames = parameter.Name;
            newRate = reaction.ReactionRate;
            if ~strcmp(oldRate, newRate)
                warning("Reaction rate for reaction %s changed from %s to %s.", ...
                    reaction.Name, oldRate, newRate);
            end
        end
    end
end