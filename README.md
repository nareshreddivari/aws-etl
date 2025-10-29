# AWS ETL Extended PoC

This PoC demonstrates an AWS ETL pipeline with Terraform, using modular IaC and CI/CD pipelines.

## Features
- AWS Lambda (Python handler)
- AWS Glue Job (Python ETL script)
- EventBridge Rule (Triggers Lambda every 5 min)
- Modular Terraform structure
- GitHub Actions & Azure DevOps pipelines
- Security scans (Checkov, Trivy)

## How to Run
1. Configure AWS credentials in GitHub/Azure DevOps secrets.
2. Run pipeline to deploy Lambda, Glue, EventBridge.
3. Monitor logs in CloudWatch.

ou want to automate Pull Request (PR) review assignment to CODEOWNERS when a developer creates a PR for a new feature branch.
Let’s go step-by-step so you get the complete setup with all required files:

🧩 Requirement Summary
✅ When a developer raises a Pull Request (PR) (for example, merging a new feature branch → main or develop),
✅ GitHub should automatically assign reviewers mentioned in the CODEOWNERS file.
✅ The PR should automatically request review from those owners (team members or users).
✅ All automated using GitHub Actions.
🗂️ Folder / File Structure
Your repository will look like this:
.github/
 ├── workflows/
 │    └── pr-auto-assign.yml
 └── CODEOWNERS
🧱 Step 1: Create CODEOWNERS File
Create a file named .github/CODEOWNERS (or at the root /CODEOWNERS).
Example:
# CODEOWNERS file

# Default owner for everything
*       @org-team/codeowners

# Specific folder ownership
/frontend/   @frontend-team
/backend/    @backend-team
/infrastructure/ @devops-team
📝 You can use:
@username
@org/team-name
Multiple owners separated by spaces.
⚙️ Step 2: Create the GitHub Action Workflow
Create a new file:
.github/workflows/pr-auto-assign.yml
Example Workflow
name: Auto Assign Code Owners on PR

on:
  pull_request:
    types: [opened, reopened, synchronize]

jobs:
  assign-codeowners:
    runs-on: ubuntu-latest

    permissions:
      contents: read
      pull-requests: write

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Get changed files
        id: changed
        run: |
          echo "CHANGED_FILES<<EOF" >> $GITHUB_ENV
          git diff --name-only ${{ github.event.pull_request.base.sha }} ${{ github.event.pull_request.head.sha }} >> $GITHUB_ENV
          echo "EOF" >> $GITHUB_ENV

      - name: Assign reviewers based on CODEOWNERS
        uses: wow-actions/auto-assign-reviewer@v3
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          reviewers: 'codeowners'
          skip-draft: true
🧩 Step 3: Using an Alternative GitHub Action (Optional but powerful)
If you want more control, you can use:
👉 kentaro-m/auto-assign-action
Example:

name: Auto Assign Reviewers

on:
  pull_request:
    types: [opened, reopened]

jobs:
  auto-assign:
    runs-on: ubuntu-latest
    permissions:
      pull-requests: write

    steps:
      - name: Auto assign reviewers
        uses: kentaro-m/auto-assign-action@v2.1.0
        with:
          configuration-path: .github/auto_assign.yml
Then create this config file:
.github/auto_assign.yml
addReviewers: true
addAssignees: false

reviewers:
  - @username1
  - @username2
  - @org/team-name

skipKeywords:
  - WIP
  - draft
🚀 How It Works
Developer creates a feature branch (e.g. feature/new-ui).
They raise a Pull Request → main/develop.
GitHub Action runs automatically.
It reads CODEOWNERS or auto_assign.yml.
Automatically requests review from the listed members.
🧰 Optional Enhancements
✅ Require CODEOWNER review before merge:
Go to Repository → Settings → Branches → Branch protection rules
Enable:
✅ “Require pull request reviews before merging”
✅ “Require review from Code Owners”
✅ Slack/MS Teams notification on PR creation
✅ Auto-label PRs by path or author
✅ Auto-merge after approval
✅ Final Deliverables
File	Purpose
.github/CODEOWNERS	Defines ownership of files/folders
.github/workflows/pr-auto-assign.yml	GitHub Action to auto-assign reviewers
.github/auto_assign.yml (optional)	Extra config for reviewer assignment
Would you like me to include Slack or Teams notification integration too (so the Code Owners get notified when a PR is assigned)?
I can extend the workflow with that if needed.
You said:
Include teams notifications integration 
ChatGPT said:
Perfect ✅ — let’s extend your setup so that when a Pull Request (PR) is created, it will:
Auto-assign reviewers based on CODEOWNERS, and
Send a Microsoft Teams notification to the Code Owner group.
Below is the complete working setup with all necessary files and configurations.
🧩 Folder / File Structure
.github/
 ├── workflows/
 │    └── pr-auto-assign.yml
 ├── CODEOWNERS
 └── auto_assign.yml
🧱 Step 1: CODEOWNERS File
Create .github/CODEOWNERS:
# Default owners for everything
* @org-team/codeowners

# Folder-level ownership
/frontend/   @frontend-team
/backend/    @backend-team
/infrastructure/ @devops-team
⚙️ Step 2: Auto Assign Reviewers Action
Create .github/workflows/pr-auto-assign.yml
name: Auto Assign Code Owners and Notify Teams

on:
  pull_request:
    types: [opened, reopened, synchronize]

jobs:
  assign-and-notify:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      # ✅ Step 1: Auto-assign reviewers based on configuration
      - name: Auto assign reviewers
        uses: kentaro-m/auto-assign-action@v2.1.0
        with:
          configuration-path: .github/auto_assign.yml

      # ✅ Step 2: Send Teams Notification
      - name: Send Microsoft Teams Notification
        uses: jdcargile/ms-teams-notification@v1.3
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          teams-webhook-url: ${{ secrets.TEAMS_WEBHOOK_URL }}
          notification-summary: "🚀 New Pull Request Created"
          notification-color: 0076D7
          timezone: "Asia/Kolkata"
          message: |
            **A new PR has been created**
            🏷️ **Title:** ${{ github.event.pull_request.title }}
            👤 **Author:** ${{ github.event.pull_request.user.login }}
            🔗 [View Pull Request](${{ github.event.pull_request.html_url }})
            🧩 **Base Branch:** ${{ github.event.pull_request.base.ref }}
            🌱 **Feature Branch:** ${{ github.event.pull_request.head.ref }}
⚙️ Step 3: Auto Assign Config File
Create .github/auto_assign.yml:
addReviewers: true
addAssignees: false

reviewers:
  - @org-team/codeowners
  - @frontend-team
  - @backend-team

skipKeywords:
  - WIP
  - draft
⚙️ Step 4: Setup Microsoft Teams Webhook
You’ll need an incoming webhook in your Teams channel:
🔧 Steps:
In Microsoft Teams → Go to your desired channel.
Click “Connectors” → “Incoming Webhook” → Configure.
Give it a name (e.g., “GitHub PR Notifications”).
Copy the Webhook URL generated.
In your GitHub repository, go to
→ Settings → Secrets and variables → Actions → New repository secret
Name: TEAMS_WEBHOOK_URL
Value: (paste your webhook URL)
✅ Step 5: Branch Protection (Optional but Recommended)
To ensure Code Owners must review:
Go to Settings → Branches → Branch protection rules
Add rule for main (or develop)
Enable:
✅ “Require pull request reviews before merging”
✅ “Require review from Code Owners”
🧩 End-to-End Flow
Step	Action	Result
🧑‍💻 Developer creates PR	feature/new-api → main	
🤖 GitHub Action runs	Assigns reviewers from CODEOWNERS	
💬 Teams Notification	Message sent to Teams channel	
👥 Code Owners	Review PR before merge	
🔔 Example Teams Notification
When a new PR is raised, your Teams message will look like:
🚀 New Pull Request Created
🏷️ Title: Add new Payment Gateway Integration
👤 Author: @kavya-m
🔗 View Pull Request
🧩 Base Branch: main
🌱 Feature Branch: feature/payment-gateway
✅ Deliverables
File	Purpose
.github/CODEOWNERS	Defines ownership of code areas
.github/auto_assign.yml	Defines which reviewers get assigned
.github/workflows/pr-auto-assign.yml	Automates assignment + Teams notification
TEAMS_WEBHOOK_URL secret	Authenticates the Teams message
Would you like me to also include Slack notification support in the same workflow (as an optional parallel job)? It’s easy to add both Teams + Slack in the same
