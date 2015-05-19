module Overcloud
  module Deployment
 
    def get_plan(plan_name)
      service('Planning').plans.find_by_name(plan_name)
    end
    
    def edit_plan_parameters(plan_name, parameters)
      get_plan(plan_name).patch(:parameters => parameters)
    end
    
    def edit_plan_deployment_role_count(plan_name, role_name, count)
      parameter = {"name" => role_name + "-1::count", "value" => count.to_s}
      edit_plan_parameters(plan_name, [count_parameter])
    end
    
    def edit_plan_deployment_role_image(plan_name, role_name, image_uuid)
      parameter = {"name" => role_name + "-1::Image", "value" => image_uuid}
      edit_plan_parameters([parameter])
    end
    
    def edit_plan_deployment_role_flavor(plan_name, role_name, flavor_name)
      parameter = {"name" => role_name + "-1::Flavor", "value" => flavor_name}
      edit_plan_parameters(plan_name, [parameter])
    end
    
    def deploy_plan(plan)
      stack_parameters = {
        :stack_name => plan.name,
        :template => plan.master_template,
        :environment => plan.environment,
        :files => plan.provider_resource_templates,
        :password => @password,
        :timeout_mins => 60,
        :disable_rollback => true
      }
      service('Orchestration').stacks.new.save(stack_parameters)
    end
    
    def get_stack(stack_name)
      service('Orchestration').stacks.get(stack_name)
    end
  
  end
end