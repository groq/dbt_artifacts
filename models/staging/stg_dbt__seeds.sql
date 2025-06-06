with
    base as (select * from {{ ref("dbt_artifacts","seeds") }}),
    enhanced as (

        select
            {{ dbt_artifacts.generate_surrogate_key(["command_invocation_id", "node_id"]) }}
            as seed_execution_id,
            command_invocation_id,
            node_id,
            run_started_at,
            {% if target.type == "sqlserver" %} "database"
            {% else %} database
            {% endif %},
            {% if target.type == "sqlserver" %} "schema"
            {% else %} schema
            {% endif %},
            name,
            package_name,
            path,
            checksum,
            meta,
            alias
        from base

    )

select *
from enhanced

