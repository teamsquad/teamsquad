class CreateCoreViews < ActiveRecord::Migration
  def self.up
    execute "create view home_teams as
      SELECT
        *
      FROM
        teams"
    
    execute "create view away_teams as
      SELECT
        *
      FROM
        teams"

    execute "create view standings as
      SELECT
        gt.team_id as id,
        gt.group_id,
        gt.team_id,
        sum(CASE WHEN g.hometeam_id=gt.team_id THEN 1 ELSE 0 END) AS homeplayed, 
        coalesce(sum(CASE WHEN g.hometeam_id=gt.team_id AND g.home_score>g.away_score THEN 1 END),0) AS homewon,
        coalesce(sum(CASE WHEN g.hometeam_id=gt.team_id AND g.home_score=g.away_score THEN 1 END),0) AS homedrawn,
        coalesce(sum(CASE WHEN g.hometeam_id=gt.team_id AND g.home_score<g.away_score THEN 1 END),0) AS homelost,
        coalesce(sum(CASE WHEN g.hometeam_id=gt.team_id THEN g.home_score ELSE 0 END),0) AS homefor,
        coalesce(sum(CASE WHEN g.hometeam_id=gt.team_id THEN g.away_score ELSE 0 END),0) AS homeagainst,
        sum(CASE WHEN g.awayteam_id=gt.team_id THEN 1 ELSE 0 END) AS awayplayed,
        coalesce(sum(CASE WHEN g.awayteam_id=gt.team_id AND g.home_score>g.away_score THEN 1 END),0) AS awaylost,
        coalesce(sum(CASE WHEN g.awayteam_id=gt.team_id AND g.home_score=g.away_score THEN 1 END),0) AS awaydrawn,
        coalesce(sum(CASE WHEN g.awayteam_id=gt.team_id AND g.home_score<g.away_score THEN 1 END),0) AS awaywon,
        coalesce(sum(CASE WHEN g.awayteam_id=gt.team_id THEN g.home_score ELSE 0 END),0) AS awayagainst,
        coalesce(sum(CASE WHEN g.awayteam_id=gt.team_id THEN g.away_score ELSE 0 END),0) AS awayfor,
        coalesce(sum(CASE WHEN g.hometeam_id=gt.team_id THEN home_points ELSE away_points END),0) AS totalpoints
      FROM
        groups_teams gt
      LEFT JOIN
        games g ON g.group_id=gt.group_id AND gt.team_id in (g.hometeam_id, g.awayteam_id) AND g.played='true'
      GROUP BY
        gt.group_id,  
        gt.team_id"
    
    execute "create view game_months as
      SELECT
        s.competition_id,
        f.played,
        min(kickoff) as date,
        to_char(f.kickoff, 'Month YYYY') as pretty_date,
        to_char(f.kickoff, 'YYYYMM')as yyyymm
      FROM
        games f
      LEFT JOIN
        groups g ON f.group_id = g.id
      LEFT JOIN
        stages s ON g.stage_id = s.id
      GROUP BY
        s.competition_id,
        f.played,
        to_char(f.kickoff, 'Month YYYY'),
        to_char(f.kickoff, 'YYYYMM')"
        
    execute "create view game_days as
      SELECT
        s.competition_id,
        f.played,
        min(kickoff) as date,
        to_char(f.kickoff, 'Day FMDDth Month YYYY') as pretty_date,
        to_char(f.kickoff, 'YYYYMMDD') as yyyymmdd,
        to_char(f.kickoff, 'YYYYMM') as yyyymm
      FROM
        games f
      LEFT JOIN
        groups g ON f.group_id = g.id
      LEFT JOIN
        stages s ON g.stage_id = s.id
      GROUP BY
        s.competition_id,
        f.played,
        to_char(f.kickoff, 'Day FMDDth Month YYYY'),
        to_char(f.kickoff, 'YYYYMMDD'),
        to_char(f.kickoff, 'YYYYMM')"
        
    execute "create view team_game_days as
      SELECT
        t.id as team_id,
        s.competition_id,
        f.played,
        min(kickoff) as date,
        to_char(f.kickoff, 'Day FMDDth Month YYYY') as pretty_date,
        to_char(f.kickoff, 'YYYYMMDD') as yyyymmdd,
        to_char(f.kickoff, 'YYYYMM') as yyyymm
      FROM
        teams t
      JOIN
        games f ON (f.hometeam_id = t.id OR f.awayteam_id = t.id)
      JOIN
        groups g ON f.group_id = g.id
      JOIN
        stages s ON g.stage_id = s.id
      GROUP BY
        t.id,
        s.competition_id,
        f.played,
        to_char(f.kickoff, 'Day FMDDth Month YYYY'),
        to_char(f.kickoff, 'YYYYMMDD'),
        to_char(f.kickoff, 'YYYYMM')"
        
    execute "create view matches as
      SELECT
        g.stage_id,
        s.competition_id,
        c.season_id,
        to_char(f.kickoff, 'Day FMDDth Month YYYY') as pretty_date,
        to_char(f.kickoff, 'Dy FMHH:MIam') as pretty_time,
        to_char(f.kickoff, 'YYYYMMDD') as yyyymmdd,
        to_char(f.kickoff, 'YYYYMM')as yyyymm,
        f.*
      FROM
        games f
      LEFT JOIN
        groups g ON f.group_id = g.id
      LEFT JOIN
        stages s ON g.stage_id = s.id
      LEFT JOIN
        competitions c ON s.competition_id = c.id"
        
    execute "create view team_matches as
      SELECT
        t.id as team_id,
        g.stage_id,
        s.competition_id,
        c.season_id,
        to_char(f.kickoff, 'Day FMDDth Month YYYY') as pretty_date,
        to_char(f.kickoff, 'Dy FMHH:MIam') as pretty_time,
        to_char(f.kickoff, 'YYYYMMDD') as yyyymmdd,
        to_char(f.kickoff, 'YYYYMM')as yyyymm,
        f.*
      FROM
        teams t
      JOIN
        games f ON (f.hometeam_id = t.id OR f.awayteam_id = t.id)
      JOIN
        groups g ON f.group_id = g.id
      JOIN
        stages s ON g.stage_id = s.id
      JOIN
        competitions c ON s.competition_id = c.id"
  end

  def self.down
    execute "drop view team_matches"
    execute "drop view matches"
    execute "drop view team_game_days"
    execute "drop view game_days"
    execute "drop view game_months"
    execute "drop view standings"
    execute "drop view away_teams"
    execute "drop view home_teams"
  end
end
