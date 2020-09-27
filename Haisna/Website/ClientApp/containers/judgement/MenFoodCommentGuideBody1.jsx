import React from 'react';
import PropTypes from 'prop-types';
import { Field } from 'redux-form';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { bindActionCreators } from 'redux';
import { actions as judCmtStcActions } from '../../modules/preference/judCmtStcModule';
import { setModeValue, deleteValue } from '../../modules/judgement/interviewModule';

const ButtonStyle = styled.p`
  border: 1px solid;
  width: 60px;
  text-align: center;
  padding: 0;
  margin: 1px;
`;
const commentFlag = 'Food';
class MenFoodCommentGuideBody1 extends React.Component {
  constructor(props) {
    super(props);
    this.handleButtonClick = this.handleButtonClick.bind(this);
  }
  // ボタンを押す時の処理
  handleButtonClick({ values, mode }) {
    const { onOpenGuide, actions, foodadvicedata, onDeleteComment, verflag } = this.props;
    const { selectfoodlist } = values;
    const varjudcmtcd = [];
    for (let i = 0; i < foodadvicedata.length; i += 1) {
      varjudcmtcd.push(foodadvicedata[i].judcmtcd);
    }
    if (mode !== 'A') {
      if (!selectfoodlist || Number(selectfoodlist) === 0) {
        alert('編集する行が選択されていません。');
        return;
      }
    }
    if (mode === 'D') {
      onDeleteComment({ selectfoodlist });
    } else {
      onOpenGuide({ mode, actions, initialSelected: varjudcmtcd, selectfoodlist, verflag });
    }
  }

  render() {
    const { handleSubmit, foodadvicedata } = this.props;
    return (
      <div style={{ height: 170 }}>
        <div>食習慣コメント</div>
        <div>
          <div style={{ float: 'left' }}>
            <Field name="selectfoodlist" component="select" style={{ width: '600px' }} size="7" >
              {foodadvicedata && foodadvicedata.map((rec, index) => (
                <option key={index.toString()} value={rec.seq}>{rec.judcmtstc}</option>
              ))}
            </Field>
          </div>
          <div style={{ float: 'left', border: '1px solid', padding: '1px', marginLeft: '2px' }}>
            <ButtonStyle>
              <a role="presentation" onClick={handleSubmit((values) => this.handleButtonClick({ values, mode: 'A' }))} style={{ color: '#006699', cursor: 'pointer' }} >追加 </a>
            </ButtonStyle>
            <ButtonStyle>
              <a role="presentation" onClick={handleSubmit((values) => this.handleButtonClick({ values, mode: 'I' }))} style={{ color: '#006699', cursor: 'pointer' }}>挿入</a>
            </ButtonStyle>
            <ButtonStyle>
              <a role="presentation" onClick={handleSubmit((values) => this.handleButtonClick({ values, mode: 'C' }))} style={{ color: '#006699', cursor: 'pointer' }}>修正</a>
            </ButtonStyle>
            <ButtonStyle>
              <a role="presentation" onClick={handleSubmit((values) => this.handleButtonClick({ values, mode: 'D' }))} style={{ color: '#006699', cursor: 'pointer' }}>削除</a>
            </ButtonStyle>
          </div>
        </div>
      </div>

    );
  }
}

MenFoodCommentGuideBody1.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  verflag: PropTypes.bool.isRequired,
  foodadvicedata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onOpenGuide: PropTypes.func.isRequired,
  actions: PropTypes.shape().isRequired,
  onDeleteComment: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  foodadvicedata: state.app.judgement.interview.menFoodCommentGuide.foodadvicedata,
});

const mapDispatchToProps = (dispatch) => ({
  onOpenGuide: ({ mode, actions, initialSelected, selectfoodlist, verflag }) => {
    let judClassCd = null;
    if (verflag) {
      judClassCd = 51;
    } else {
      judClassCd = 57;
    }
    actions.openAdviceCommentGuideRequest({
      judClassCd,
      initialSelected,
    });
    dispatch(setModeValue({ mode, selectfoodlist, commentFlag }));
  },
  onDeleteComment: ({ selectfoodlist }) => {
    dispatch(deleteValue({ selectfoodlist, commentFlag }));
  },
  actions: bindActionCreators(judCmtStcActions, dispatch),

});

export default connect(mapStateToProps, mapDispatchToProps)(MenFoodCommentGuideBody1);
