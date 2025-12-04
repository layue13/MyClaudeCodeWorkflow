# My Claude Code Workflow

A comprehensive development workflow configuration for Claude Code, designed to enhance productivity and maintain code quality through intelligent agent coordination and systematic development practices.

## Overview

This repository contains a curated set of development guidelines, agent configurations, and workflow optimizations specifically designed for use with Claude Code. It emphasizes incremental development, intelligent knowledge gathering, and maintaining high code quality standards.

## Key Features

### 🧠 Intelligent Knowledge Gathering
- **knowledge-scout agent** for systematic research and information gathering
- Prioritizes authoritative sources and cached knowledge graphs
- Supports concurrent research operations for maximum efficiency

### 📋 Structured Development Process
- **Incremental progress over big bangs** - Small, testable changes
- **Stage-based planning** with clear success criteria
- **3-attempt rule** for debugging and problem-solving

### 🎯 Quality-First Approach
- Test-driven development practices
- Comprehensive code quality gates
- Automated linting and formatting requirements

## Structure

```
.
├── CLAUDE.md              # Main development guidelines and instructions
├── .claude/
│   └── agents/
│       └── knowledge-scout.md  # Knowledge gathering agent configuration
└── README.md              # This file
```

## Core Philosophy

### Development Principles
- **Learning from existing code** - Study patterns before implementing
- **Pragmatic over dogmatic** - Adapt to project reality
- **Clear intent over clever code** - Be boring and obvious
- **Single responsibility** per function/class

### Quality Standards
- Every commit must compile and pass tests
- Include tests for new functionality
- Follow project formatting/linting standards
- Clear commit messages explaining "why"

## Quick Install

### One-Line Installation

```bash
curl -fsSL https://github.com/layue13/MyClaudeCodeWorkflow/raw/main/ccw.sh | bash
```

This will install the workflow configuration globally to your `~/.claude/` directory.

### Manual Installation

```bash
# Download the installer
wget https://github.com/layue13/MyClaudeCodeWorkflow/raw/main/ccw.sh

# Make it executable and run
chmod +x ccw.sh
./ccw.sh install
```

### What Gets Installed

The installer copies the following files to your global Claude configuration:

```
~/.claude/
├── CLAUDE.md              # Development guidelines and best practices
└── agents/
    └── knowledge-scout.md # Intelligent research agent configuration
```

### After Installation

Once installed, the workflow is automatically available in all your projects. Simply use Claude Code normally:

```bash
cd your-project
claude "help me implement user authentication"
```

The workflow will automatically:
- Break complex tasks into manageable stages
- Use knowledge-scout for technical research
- Follow TDD development practices
- Learn from your existing codebase patterns

### Management Commands

```bash
# Update to latest version
./ccw.sh update

# Remove the workflow
./ccw.sh uninstall
```

## Required MCP Servers

This workflow requires the following MCP (Model Context Protocol) servers to function properly:

| MCP Server | Purpose | Used By |
|------------|---------|---------|
| **neo4j-memory** | Knowledge graph storage and retrieval | knowledge-scout |
| **sequential-thinking** | Structured reasoning and problem decomposition | knowledge-scout |
| **searxng** | Web search and URL content reading | knowledge-scout |
| **time** | Current time for knowledge freshness tracking | knowledge-scout |
| **tmux** | Terminal session management (optional) | General workflow |

### MCP Installation

```bash
# neo4j-memory - Knowledge graph with Neo4j backend
claude mcp add -s user neo4j-memory \
  -e NEO4J_URI=bolt://your-neo4j-host:7687 \
  -e NEO4J_USERNAME=neo4j \
  -e NEO4J_PASSWORD=your-password \
  -- uvx mcp-neo4j-memory

# sequential-thinking - Structured reasoning
claude mcp add -s user sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking

# searxng - Web search (requires SearXNG instance)
claude mcp add -s user searxng -e SEARXNG_URL=http://your-searxng-instance -- npx -y mcp-searxng

# time - Current time provider
claude mcp add -s user time -- uvx mcp-server-time

# tmux - Terminal session management (optional)
claude mcp add -s user tmux -- npx -y tmux-mcp --shell-type=bash
```

### Verify Installation

```bash
claude mcp list
```

All servers should show "Connected" status.

## Getting Started

1. **Install the workflow** - Use the one-line installer above
2. **Configure MCP servers** - Install required MCP servers listed above
3. **Review CLAUDE.md** - Understand the development guidelines
4. **Start coding** - Use Claude Code with enhanced workflow capabilities

## Usage

The workflow is designed to be used with Claude Code's agent system. Key practices include:

- **Planning & Staging**: Break complex work into 3-5 manageable stages
- **Implementation Flow**: Understand → Test → Implement → Refactor → Commit
- **Knowledge Gathering**: Use knowledge-scout agent for research needs
- **Quality Gates**: Ensure tests pass and code follows conventions

## Agent Configuration

### knowledge-scout
Specialized agent for systematic information gathering:
- Research technical concepts and frameworks
- Investigate current best practices
- Verify information from authoritative sources
- Support concurrent research operations

## Contributing

When working with this workflow:

1. Follow the development guidelines in CLAUDE.md
2. Use the knowledge-scout agent for research needs
3. Maintain the incremental development approach
4. Ensure all quality gates are met before committing

## License

This workflow configuration is designed for personal and professional development use with Claude Code.