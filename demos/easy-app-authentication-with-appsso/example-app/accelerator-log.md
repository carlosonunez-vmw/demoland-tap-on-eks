# Accelerator Log

## Options
```json
{
  "authority" : "AUTHSERVER-ISSUER-URI",
  "authorityLabelKey" : "my-sso",
  "authorityLabelValue" : "true",
  "namespace" : "my-apps",
  "projectName" : "angular-frontend",
  "useSingleSignOn" : true
}
```
## Log
```
┏ engine (Chain)
┃  Info Running Chain(GeneratorValidationTransform, UniquePath)
┃ ┏ ┏ engine.transformations[0].validated (Combo)
┃ ┃ ┃  Info Combo running as Let
┃ ┃ ┃ engine.transformations[0].validated.delegate (Let)
┃ ┃ ┃ Debug Adding symbol backendServiceResourceName with value 'customer-profile-backend.namespace'
┃ ┃ ┃ Debug Adding symbol workloadResourceName with value 'angular-frontend'
┃ ┃ ┃ ┏ engine.transformations[0].validated.delegate.in (Chain)
┃ ┃ ┃ ┃  Info Running Chain(Combo, Combo, Combo, Combo, Combo, Combo, Provenance)
┃ ┃ ┃ ┃ ┏ engine.transformations[0].validated.delegate.in.transformations[0] (Combo)
┃ ┃ ┃ ┃ ┃  Info Combo running as Chain
┃ ┃ ┃ ┃ ┃ engine.transformations[0].validated.delegate.in.transformations[0].delegate (Chain)
┃ ┃ ┃ ┃ ┃  Info Running Chain(ReplaceText)
┃ ┃ ┃ ┃ ┃ ┏ engine.transformations[0].validated.delegate.in.transformations[0].delegate.transformations[0] (ReplaceText)
┃ ┃ ┃ ┃ ┗ ┗  Info Will replace [http://backend/api/->http://customer-prof...(truncated)]
┃ ┃ ┃ ┃ ┏ engine.transformations[0].validated.delegate.in.transformations[1] (Combo)
┃ ┃ ┃ ┃ ┃  Info Combo running as Chain
┃ ┃ ┃ ┃ ┃ engine.transformations[0].validated.delegate.in.transformations[1].delegate (Chain)
┃ ┃ ┃ ┃ ┃  Info Running Chain(ReplaceText)
┃ ┃ ┃ ┃ ┃ ┏ engine.transformations[0].validated.delegate.in.transformations[1].delegate.transformations[0] (ReplaceText)
┃ ┃ ┃ ┃ ┗ ┗  Info Will replace [angular-frontend->angular-frontend]
┃ ┃ ┃ ┃ ┏ engine.transformations[0].validated.delegate.in.transformations[2] (Combo)
┃ ┃ ┃ ┃ ┃  Info Condition (#useSingleSignOn == true) evaluated to true
┃ ┃ ┃ ┃ ┃  Info Combo running as Chain
┃ ┃ ┃ ┃ ┃ engine.transformations[0].validated.delegate.in.transformations[2].delegate (Chain)
┃ ┃ ┃ ┃ ┃  Info Running Chain(ReplaceText)
┃ ┃ ┃ ┃ ┃ ┏ engine.transformations[0].validated.delegate.in.transformations[2].delegate.transformations[0] (ReplaceText)
┃ ┃ ┃ ┃ ┗ ┗  Info Will replace [<your-authserver-match-label-key>->my-sso, <your-authserver-uri>->AUTHSERVER-ISSUER-UR...(truncated), <your-namespace>->my-apps, <your-client-id>->angular-frontend, <your-authserver-match-label-value>->true]
┃ ┃ ┃ ┃ ┏ engine.transformations[0].validated.delegate.in.transformations[3] (Combo)
┃ ┃ ┃ ┃ ┃  Info Combo running as Chain
┃ ┃ ┃ ┃ ┃ engine.transformations[0].validated.delegate.in.transformations[3].delegate (Chain)
┃ ┃ ┃ ┃ ┃  Info Running Chain(Merge, UniquePath)
┃ ┃ ┃ ┃ ┃ ┏ engine.transformations[0].validated.delegate.in.transformations[3].delegate.transformations[0] (Merge)
┃ ┃ ┃ ┃ ┃ ┃  Info Running Merge(InvokeFragment, Combo)
┃ ┃ ┃ ┃ ┃ ┃ ┏ engine.transformations[0].validated.delegate.in.transformations[3].delegate.transformations[0].sources[0] (InvokeFragment)
┃ ┃ ┃ ┃ ┃ ┃ ┃ ┏ engine.transformations[0].validated.delegate.in.transformations[3].delegate.transformations[0].sources[0].validated (Combo)
┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃  Info Condition (#bsGitRepository != null) evaluated to false
┃ ┃ ┃ ┃ ┃ ┃ ┗ ┗ null ()
┃ ┃ ┃ ┃ ┃ ┃ ┏ engine.transformations[0].validated.delegate.in.transformations[3].delegate.transformations[0].sources[1] (Combo)
┃ ┃ ┃ ┃ ┃ ┃ ┃  Info Combo running as Include
┃ ┃ ┃ ┃ ┃ ┃ ┃ engine.transformations[0].validated.delegate.in.transformations[3].delegate.transformations[0].sources[1].delegate (Include)
┃ ┃ ┃ ┃ ┃ ┃ ┃  Info Will include [**]
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug .browserslistrc matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug .editorconfig matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug .gitignore matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug .tanzuignore matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug AUTHORIZATION.md matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug DeploymentTopology.png matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug LICENSE matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug README.md matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug angular.json matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug karma.conf.js matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug package-lock.json matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug package.json matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/app-config.service.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/AuthorizationTypes.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authInterceptor.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authInterceptor.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authentication-utilities.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authentication-utilities.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authorization-config.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authorization.service.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authorization.service.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/configTypes.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/create-customer-profile.component.css matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/create-customer-profile.component.html matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/create-customer-profile.component.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/create-customer-profile.component.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/customer-profile.module.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/customer-profile.service.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/customer-profile.service.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/list-customer-profiles.component.css matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/list-customer-profiles.component.html matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/list-customer-profiles.component.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/list-customer-profiles.component.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/home.component.css matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/home.component.html matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/home.component.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/home.component.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/top-bar/top-bar.component.css matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/top-bar/top-bar.component.html matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/top-bar/top-bar.component.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.component.html matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.component.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.component.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.module.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.service.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.service.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/utils.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/utils.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/assets/.gitkeep matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/environments/environment.prod.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/environments/environment.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/favicon.ico matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/index.html matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/main.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/polyfills.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/proxy.conf.json matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/styles.css matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/test.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug tekton/README.md matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug tekton/test-pipeline.yaml matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug tsconfig.app.json matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug tsconfig.json matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug tsconfig.spec.json matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug nginx.conf matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug catalog/catalog-info.yaml matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug config/workload.yaml matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/app-routing.module.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/app.module.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┗ ┗ Debug src/assets/auth.conf.json matched [**] -> included
┃ ┃ ┃ ┃ ┗ ╺ engine.transformations[0].validated.delegate.in.transformations[3].delegate.transformations[1] (UniquePath)
┃ ┃ ┃ ┃ ┏ engine.transformations[0].validated.delegate.in.transformations[4] (Combo)
┃ ┃ ┃ ┃ ┗  Info Condition (!#useSingleSignOn) evaluated to false
┃ ┃ ┃ ┃ ┏ engine.transformations[0].validated.delegate.in.transformations[5] (Combo)
┃ ┃ ┃ ┃ ┃  Info Combo running as Chain
┃ ┃ ┃ ┃ ┃ engine.transformations[0].validated.delegate.in.transformations[5].delegate (Chain)
┃ ┃ ┃ ┃ ┃  Info Running Chain(Include, Exclude)
┃ ┃ ┃ ┃ ┃ ┏ engine.transformations[0].validated.delegate.in.transformations[5].delegate.transformations[0] (Include)
┃ ┃ ┃ ┃ ┃ ┃  Info Will include [**]
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/home.component.html matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/app-config.service.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/utils.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug karma.conf.js matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug angular.json matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug AUTHORIZATION.md matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/environments/environment.prod.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/environments/environment.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/create-customer-profile.component.html matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.service.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug .editorconfig matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authorization.service.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug LICENSE matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/favicon.ico matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authorization-config.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug nginx.conf matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/configTypes.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/app.module.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/top-bar/top-bar.component.html matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug DeploymentTopology.png matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/polyfills.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/index.html matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/proxy.conf.json matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.service.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.module.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug README.md matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/assets/auth.conf.json matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/create-customer-profile.component.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/create-customer-profile.component.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug tsconfig.json matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug tekton/README.md matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/home.component.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug tsconfig.app.json matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authentication-utilities.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/app-routing.module.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug .gitignore matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug tsconfig.spec.json matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug package-lock.json matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/test.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/customer-profile.service.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/home.component.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/list-customer-profiles.component.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/top-bar/top-bar.component.css matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/list-customer-profiles.component.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug tekton/test-pipeline.yaml matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/customer-profile.service.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/list-customer-profiles.component.css matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/AuthorizationTypes.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authInterceptor.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug .tanzuignore matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.component.html matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authentication-utilities.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/home.component.css matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/create-customer-profile.component.css matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.component.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.component.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authInterceptor.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/list-customer-profiles.component.html matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug catalog/catalog-info.yaml matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/main.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug config/workload.yaml matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/assets/.gitkeep matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug .browserslistrc matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/top-bar/top-bar.component.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug package.json matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/utils.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/customer-profile.module.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/styles.css matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┗ Debug src/app/authorization/authorization.service.spec.ts matched [**] -> included
┃ ┃ ┃ ┃ ┃ ┏ engine.transformations[0].validated.delegate.in.transformations[5].delegate.transformations[1] (Exclude)
┃ ┃ ┃ ┃ ┃ ┃  Info Will exclude [tekton/**]
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/home.component.html didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/app-config.service.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/utils.spec.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug karma.conf.js didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug angular.json didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug AUTHORIZATION.md didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/environments/environment.prod.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/environments/environment.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/create-customer-profile.component.html didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.service.spec.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug .editorconfig didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authorization.service.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug LICENSE didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/favicon.ico didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authorization-config.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug nginx.conf didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/configTypes.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/app.module.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/top-bar/top-bar.component.html didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug DeploymentTopology.png didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/polyfills.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/index.html didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/proxy.conf.json didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.service.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.module.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug README.md didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/assets/auth.conf.json didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/create-customer-profile.component.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/create-customer-profile.component.spec.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug tsconfig.json didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug tekton/README.md matched [tekton/**] -> excluded
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/home.component.spec.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug tsconfig.app.json didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authentication-utilities.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/app-routing.module.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug .gitignore didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug tsconfig.spec.json didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug package-lock.json didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/test.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/customer-profile.service.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/home.component.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/list-customer-profiles.component.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/top-bar/top-bar.component.css didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/list-customer-profiles.component.spec.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug tekton/test-pipeline.yaml matched [tekton/**] -> excluded
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/customer-profile.service.spec.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/list-customer-profiles.component.css didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/AuthorizationTypes.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authInterceptor.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug .tanzuignore didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.component.html didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authentication-utilities.spec.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/home.component.css didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/create-customer-profile.component.css didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.component.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/user-profile/user-profile.component.spec.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/authorization/authInterceptor.spec.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/list-customer-profiles.component.html didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug catalog/catalog-info.yaml didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/main.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug config/workload.yaml didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/assets/.gitkeep didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug .browserslistrc didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/top-bar/top-bar.component.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug package.json didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/utils.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/app/customer-profile/customer-profile.module.ts didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┃ ┃ Debug src/styles.css didn't match [tekton/**] -> included
┃ ┃ ┃ ┃ ┗ ┗ Debug src/app/authorization/authorization.service.spec.ts didn't match [tekton/**] -> included
┃ ┗ ┗ ┗ ╺ engine.transformations[0].validated.delegate.in.transformations[6] (Provenance)
┗ ╺ engine.transformations[1] (UniquePath)
```
