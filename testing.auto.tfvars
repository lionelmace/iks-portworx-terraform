##############################################################################
## Global Variables
##############################################################################




##############################################################################
## Cluster ROKS
##############################################################################
# iks_machine_flavor = "bx2.4x16"
# Portworx requires 3 nodes, each 16 vCPU
iks_machine_flavor = "bx2.16x64" 

# Available values: MasterNodeReady, OneWorkerNodeReady, or IngressReady
iks_wait_till          = "OneWorkerNodeReady"
iks_update_all_workers = false