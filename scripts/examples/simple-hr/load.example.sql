prompt loading example data for simple hr example

prompt loading locations
begin
    hr_api.insert_location('INNOVATION_PARIS', 'Research and Development, Paris', '123 Rue de St Claire', 'Paris');
    hr_api.insert_location('CUSTOMER_RELATIONS_NEW_YORK', 'Sales and Marketing, New York', '777 Broadway St', 'New York City');
    hr_api.insert_location('RESEARCH_TOKYO', 'Research and Development, Tokyo', '93 Fuji Ave', 'Tokyo');
    hr_api.insert_location('OPERATIONS_SYDNEY', 'Operations and Logistics, Sydney', '10 Opera Blvd', 'Sydney');
    hr_api.insert_location('HEADQUARTERS_BERN', 'Corporate Offices, Bern', '42 Cooperation Way', 'Bern'); 
end;
/

begin
    hr_api.insert_department('EXECUTIVE', 'Executive', 'Corporate Leadership');
    hr_api.insert_department('ACCOUNTING', 'Accounting', 'Accounting and Recordkeeping');
    hr_api.insert_department('MARKETING', 'Marketing', 'Marketing and Adverstising');
    hr_api.insert_department('PURCHASING', 'Purchasing', 'Purchasing and Fulfillment');
    hr_api.insert_department('SALES', 'Sales', 'Sales and Customer Relations');
    hr_api.insert_department('LOGISTICS', 'Logistics', 'Shipping and Receiving Logistics');
    hr_api.insert_department('INNOVATION', 'Information Management', 'Information Management, Research and Innovation');
end;
/

begin
    hr_api.insert_job('CEO', 'Chief Executive Officer');
    hr_api.insert_job('CFO', 'Chief Financial Officer');
    hr_api.insert_job('EXECUTIVE', 'Executive Officer');
    hr_api.insert_job('MANAGER', 'Corporate Manager');
    hr_api.insert_job('REPRESENTATIVE', 'Corporate Representative');
    hr_api.insert_job('LEADER', 'Team Lead');
    hr_api.insert_job('ASSOCIATE', 'Corporate Associate');
    hr_api.insert_job('ENGINEER', 'Engineer');
    hr_api.insert_job('ARCHITECT', 'Architect');
end;
/

declare
    l_founders date := sysdate - interval '7' year;
    l_core date := sysdate - interval '5' year;
    l_recruits date := sysdate - interval '2' year;
begin

    hr_api.insert_employee('Frida', 'Kahlo', 100000, l_founders, 'CEO', 'EXECUTIVE', 'HEADQUARTERS_BERN');
    hr_api.insert_employee('Mariko', 'Takada', 100000, l_founders, 'CFO', 'EXECUTIVE', 'HEADQUARTERS_BERN', 'frida.kahlo@futureco.com');
    hr_api.insert_employee('Edward', 'Benning', 90000, l_core, 'EXECUTIVE', 'EXECUTIVE', null, 'mariko.takada@futureco.com');
    hr_api.insert_employee('Jack', 'Chan', 90000, l_core, 'EXECUTIVE', 'EXECUTIVE', null, 'mariko.takada@futureco.com');
    hr_api.insert_employee('Gina', 'Davis', 90000, l_core, 'EXECUTIVE', 'EXECUTIVE', 'HEADQUARTERS_BERN', 'mariko.takada@futureco.com');
    hr_api.insert_employee('Joan', 'Winters', 60000, l_recruits, 'ASSOCIATE', 'EXECUTIVE', 'HEADQUARTERS_BERN');
    
    hr_api.insert_employee('Hakaido', 'Tawaza', 70000, l_founders, 'EXECUTIVE', 'ACCOUNTING', 'OPERATIONS_SYDNEY', 'mariko.takada@futureco.com');
    hr_api.insert_employee('Jamie', 'Rivera', 50000, l_core, 'ASSOCIATE', 'ACCOUNTING', 'OPERATIONS_SYDNEY', 'hakaido.tawaza@futureco.com');

    hr_api.insert_employee('Douglas', 'Adams', 80000, l_founders, 'EXECUTIVE', 'MARKETING', 'CUSTOMER_RELATIONS_NEW_YORK', 'frida.kahlo@futureco.com');
    hr_api.insert_employee('Frank', 'Herbert', 70000, l_core, 'LEADER', 'MARKETING', null, 'douglas.adams@futureco.com');
    hr_api.insert_employee('Ursula', 'Leguin', 50000, l_recruits, 'ASSOCIATE', 'MARKETING', 'CUSTOMER_RELATIONS_NEW_YORK', 'frank.herbert@futureco.com');

    hr_api.insert_employee('Gina', 'Green', 50000, l_core, 'MANAGER', 'PURCHASING', 'OPERATIONS_SYDNEY', 'hakaido.tawaza@futureco.com');
    hr_api.insert_employee('Timothy', 'Bryant', 40000, l_recruits, 'ASSOCIATE', 'PURCHASING', 'OPERATIONS_SYDNEY', 'gina.green@futureco.com');
    hr_api.insert_employee('Rene', 'Descartes', 40000, l_recruits, 'ASSOCIATE', 'PURCHASING', null, 'gina.green@futureco.com');
    
    hr_api.insert_employee('Rachel', 'Sonheim', 60000, l_founders, 'EXECUTIVE', 'SALES', 'CUSTOMER_RELATIONS_NEW_YORK', 'gina.davis@futureco.com');
    hr_api.insert_employee('Niels', 'Bohr', 50000, l_core, 'REPRESENTATIVE', 'SALES', 'CUSTOMER_RELATIONS_NEW_YORK', 'rachel.sonheim@futureco.com');
    hr_api.insert_employee('Werner', 'Heisenberg', 50000, l_core, 'REPRESENTATIVE', 'SALES', null, 'rachel.sonheim@futureco.com');    
    hr_api.insert_employee('Ariel', 'West', 50000, l_core, 'REPRESENTATIVE', 'SALES', 'CUSTOMER_RELATIONS_NEW_YORK', 'rachel.sonheim@futureco.com');
    hr_api.insert_employee('Eduardo', 'Forest', 40000, l_recruits, 'ASSOCIATE', 'SALES', 'CUSTOMER_RELATIONS_NEW_YORK', 'ariel.west@futureco.com');

    hr_api.insert_employee('April', 'Gonzales', 50000, l_core, 'MANAGER', 'LOGISTICS', 'OPERATIONS_SYDNEY', 'jack.chan@futureco.com');
    hr_api.insert_employee('Emily', 'Bronte', 40000, l_core, 'LEADER', 'LOGISTICS', 'OPERATIONS_SYDNEY', 'april.gonzales@futureco.com');
    hr_api.insert_employee('Jordan', 'Rivers', 30000, l_recruits, 'ASSOCIATE', 'LOGISTICS', 'OPERATIONS_SYDNEY', 'emily.bronte@futureco.com');
    hr_api.insert_employee('Mark', 'Steward', 30000, l_recruits, 'ASSOCIATE', 'LOGISTICS', 'OPERATIONS_SYDNEY', 'emily.bronte@futureco.com');

    hr_api.insert_employee('Nikola', 'Tesla', 150000, l_founders, 'ARCHITECT', 'INNOVATION', 'INNOVATION_PARIS', 'frida.kahlo@futureco.com');
    hr_api.insert_employee('Thomas', 'Edison', 100000, l_core, 'ENGINEER', 'INNOVATION', 'INNOVATION_PARIS', 'nikola.tesla@futureco.com');
    hr_api.insert_employee('Aruna', 'Gopal', 100000, l_core, 'ENGINEER', 'INNOVATION', 'INNOVATION_PARIS', 'nikola.tesla@futureco.com');

    hr_api.insert_employee('Marie', 'Curie', 80000, l_founders, 'LEADER', 'INNOVATION', 'RESEARCH_TOKYO', 'frida.kahlo@futureco.com');    
    hr_api.insert_employee('Jillian', 'Chen', 70000, l_core, 'ASSOCIATE', 'INNOVATION', null, 'marie.curie@futureco.com');
    hr_api.insert_employee('Benjamin', 'Franklin', 70000, l_core, 'ASSOCIATE', 'INNOVATION', 'RESEARCH_TOKYO', 'marie.curie@futureco.com');
    hr_api.insert_employee('Alexa', 'Belle', 70000, l_core, 'ASSOCIATE', 'INNOVATION', 'RESEARCH_TOKYO', 'marie.curie@futureco.com');

end;

