import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import styled from 'styled-components';
import SectionBar from '../../components/SectionBar';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import { getFollowItemRequest } from '../../modules/followup/followModule';
// 変更履歴画面
import FolUpdateHistoryGuide from '../followup/FolUpdateHistoryGuide';
// 印刷履歴画面
import FollowReqHistoryGuide from '../followup/FollowReqHistoryGuide';
//  結果入力画面
import FollowInfoEditGuide from '../followup/FollowInfoEditGuide';
// 依頼状作成画面
import FollowReqEditGuide from '../followup/FollowReqEditGuide';


const Wrapper = styled.div`
  background-color: #CCCCCC;
`;

class FollowInfoHeader extends React.Component {
  componentDidMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params);
  }

  render() {
    const { followItemData } = this.props;
    return (
      <div>
        <SectionBar title="フォローアップ照会" />
        <FieldGroup>
          <FieldSet>
            <FieldItem><Wrapper>※フォロー対象検査項目:</Wrapper></FieldItem>
            {followItemData && followItemData.map((rec, index) => (
              (index === 0) ? <Label key={index.toString()}> {rec.itemname} </Label> : <Label key={index.toString()}>、{rec.itemname} </Label>
            ))}
          </FieldSet>
        </FieldGroup>
        <FolUpdateHistoryGuide />
        <FollowReqHistoryGuide />
        <FollowInfoEditGuide />
        <FollowReqEditGuide />
      </div>
    );
  }
}

FollowInfoHeader.propTypes = {
  match: PropTypes.shape().isRequired,
  onLoad: PropTypes.func.isRequired,
  followItemData: PropTypes.arrayOf(PropTypes.shape()),
};

const mapStateToProps = (state) => ({
  followItemData: state.app.followup.follow.followInfo.followItemData,
});

FollowInfoHeader.defaultProps = {
  followItemData: [],
};

const mapDispatchToProps = (dispatch) => ({
  onLoad: () => {
    // フォロー対象検査項目（判定分類）を取得
    dispatch(getFollowItemRequest());
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(FollowInfoHeader));
