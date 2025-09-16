import sys
from awsglue.utils import getResolvedOptions

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
print(f"Running Glue Job: {args['JOB_NAME']} (Extended PoC)")
