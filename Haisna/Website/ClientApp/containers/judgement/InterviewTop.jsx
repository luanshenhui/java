import React from 'react';
import { Switch, Route, withRouter } from 'react-router-dom';
import PropTypes from 'prop-types';
import PageLayout from '../../layouts/PageLayout';
import InterviewHeader from '../../containers/common/InterviewHeaderForm';
import RslUpdateHistoryMain from './RslUpdateHistoryMain';
import DiseaseHistory from './DiseaseHistory';
import MonshinNyuryokuMain from './MonshinNyuryokuMain';
import CommentListFlame from '../../containers/preference/comment/CommentListFlameGuide';
import TotalJudView from './TotalJudView';
import MenResult from './MenResult';
import EntryRecogLevelList from './EntryRecogLevelList';
import ViewOldJudCommentMain from './ViewOldJudCommentMain';
import FollowinfoTop from './FollowinfoTop';
import TotalJudEdit from './TotalJudEdit';
import Shokusyukan201210 from './Shokusyukan201210';

const InterviewTop = (props) => {
  const { match } = props;
  return (
    <PageLayout title="面接支援">
      <div>
        <InterviewHeader rsvno={match.params.rsvno} reqwin={1} />
        <Switch>
          {/* 総合判定 */}
          <Route exact path="/contents/judgement/interview/top/:rsvno/totaljudview/:grpno/:winmode" component={TotalJudView} />
          {/* 総合判定 */}
          <Route exact path="/contents/judgement/interview/top/:rsvno/totaljudview/:winmode/:grpcd/:cscd" component={TotalJudView} />
          {/* 総合判定修正 */}
          <Route exact path="/contents/judgement/interview/top/:rsvno/totaljudedit/:winmode/:grpcd/:cscd" component={TotalJudEdit} />
          {/* 総合判定修正 */}
          <Route exact path="/contents/judgement/interview/top/:rsvno/totaljudedit/:action/:winmode/:grpcd/:cscd/:csgrp" component={TotalJudEdit} />
          {/* 検査結果表示 */}
          <Route exact path="/contents/judgement/interview/top/:rsvno/:cscd/menresult/:grpno/:winmode" component={MenResult} />
          {/* 変更履歴 */}
          <Route exact path="/contents/judgement/interview/top/:rsvno/:cscd/rslupdatehistory/:grpno/:winmode" component={RslUpdateHistoryMain} />
          {/* 変更履歴 */}
          <Route exact path="/contents/judgement/interview/top/:rsvno/:cscd/rslupdatehistory/:winmode" component={RslUpdateHistoryMain} />
          {/* 病歴情報 */}
          <Route exact path="/contents/judgement/interview/top/:rsvno/:cscd/diseasehistory/:grpno/:winmode" component={DiseaseHistory} />
          {/* 病歴情報 */}
          <Route exact path="/contents/judgement/interview/top/:rsvno/:cscd/diseasehistory/:winmode" component={DiseaseHistory} />
          {/* 問診 */}
          <Route exact path="/contents/judgement/interview/top/:rsvno/:cscd/monshinnyuryoku/:grpno/:winmode" component={MonshinNyuryokuMain} />
          {/* 問診内容 */}
          <Route exact path="/contents/judgement/interview/top/:rsvno/monshinnyuryoku/:winmode" component={MonshinNyuryokuMain} />
          {/* チャート情報 */}
          <Route exact path="/contents/judgement/interview/top/:rsvno/:cscd/commentlistflame/:grpno/:winmode" component={CommentListFlame} />
          {/* 生活指導コメント */}
          <Route exact path="/contents/judgement/interview/top/:rsvno/:cscd/entryrecoglevellist/:grpno/:winmode" component={EntryRecogLevelList} />
          {/* 過去総合コメント一覧 */}
          <Route exact path="/contents/judgement/interview/top/:rsvno/:cscd/viewoldjudcomment/:winmode" component={ViewOldJudCommentMain} />
          {/* フォローアップ検索 */}
          <Route exact path="/contents/judgement/interview/top/:rsvno/:cscd/followinfo/:winmode" component={FollowinfoTop} />
          {/* 食習慣問診 */}
          <Route exact path="/contents/judgement/interview/top/:rsvno/:cscd/shokusyukan201210/:grpno/:winmode" component={Shokusyukan201210} />
        </Switch>
      </div>
    </PageLayout>
  );
};

// propTypesの定義
InterviewTop.propTypes = {
  match: PropTypes.shape().isRequired,
};

export default withRouter(InterviewTop);
