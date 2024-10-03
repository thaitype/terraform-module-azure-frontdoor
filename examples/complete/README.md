# Full Usage Example of Terraform Module

### Gen Azure Service Principal
```bash
az ad sp create-for-rbac --name "thada/event/hashicorp-meetup-2024" --role contributor --scopes /resource/subscriptions/c74a514a-dbd3-49af-8499-f9111ef33b32/resourceGroups/thw-event-front-door-demo --json-auth
```