with
    base as (select * from {{ ref("dbt_artifacts","model_executions") }}),
    enhanced as (

        select
            {{ dbt_artifacts.generate_surrogate_key(["command_invocation_id", "node_id"]) }}
            as model_execution_id,
            command_invocation_id,
            node_id,
            run_started_at,
            was_full_refresh,
            {{ split_part("thread_id", "'-'", 2) }} as thread_id,
            status,
            compile_started_at,
            query_completed_at,
            total_node_runtime,
            rows_affected
            {% if target.type == "bigquery" %}, bytes_processed {% endif %},
            materialization,
            {% if target.type == "sqlserver" %} "schema"
            {% else %} schema
            {% endif %},  -- noqa
            name,
            alias,
            message,
            adapter_response
        from base

    )

select *
from enhanced

