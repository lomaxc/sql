WITH RECURSIVE program_hierarchy AS (
    /*
    1) Anchor member:
       For each program, generate one row per child in child_program_ids.
       The "root_id" is the program's own ID, and "child_id" is each un-nested child.
    */

    SELECT
        p.program_id AS root_id,
        p.program_id AS current_id,
        unnest(p.child_program_ids) AS child_id
    FROM bootcamp.programs p

    UNION ALL

    /*
    2) Recursive member:
       Join back to programs where the "child_id" from the previous step
       becomes the "current_id" (i.e. the program_id of the child).
       Then unnest that child's child_program_ids to go deeper.
    */

    SELECT
        ph.root_id,
        c.program_id AS current_id,
        unnest(c.child_program_ids) AS child_id
    FROM bootcamp.programs c
    JOIN program_hierarchy ph
    ON ph.child_id = c.program_id
)

SELECT
    root_id,      -- the original "root" of the hierarchy
    current_id,   -- the current program
    child_id      -- a child of the current program
FROM program_hierarchy;
