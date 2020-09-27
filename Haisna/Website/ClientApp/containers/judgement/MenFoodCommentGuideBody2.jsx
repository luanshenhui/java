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
const commentFlag = 'Menu';
class MenFoodCommentGuideBody2 extends React.Component {
  constructor(props) {
    super(props);
    this.handleButtonClick = this.handleButtonClick.bind(this);
  }
  // ボタンを押す時の処理
  handleButtonClick({ values, mode }) {
    const { onOpenGuide, actions, menuadvicedata, onDeleteComment } = this.props;
    const { selectmenulist } = values;
    const varjudcmtcd = [];
    for (let i = 0; i < menuadvicedata.length; i += 1) {
      varjudcmtcd.push(menuadvicedata[i].judcmtcd);
    }
    if (mode !== 'A') {
      if (!selectmenulist || Number(selectmenulist) === 0) {
        alert('編集する行が選択されていません。');
        return;
      }
    }
    if (mode === 'D') {
      onDeleteComment({ selectmenulist });
    } else {
      onOpenGuide({ mode, actions, initialSelected: varjudcmtcd, selectmenulist });
    }
  }

  render() {
    const { handleSubmit, menuadvicedata } = this.props;
    return (
      <div style={{ height: 170 }}>
        <div>献立コメント</div>
        <div>
          <div style={{ float: 'left' }}>
            <Field name="selectmenulist" component="select" style={{ width: '600px' }} size="7" >
              {menuadvicedata && menuadvicedata.map((rec, index) => (
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

MenFoodCommentGuideBody2.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  menuadvicedata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onOpenGuide: PropTypes.func.isRequired,
  actions: PropTypes.shape().isRequired,
  onDeleteComment: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  menuadvicedata: state.app.judgement.interview.menFoodCommentGuide.menuadvicedata,
});

const mapDispatchToProps = (dispatch) => ({
  onOpenGuide: ({ mode, actions, initialSelected, selectmenulist }) => {
    const judClassCd = 52;
    actions.openAdviceCommentGuideRequest({
      judClassCd,
      initialSelected,
    });
    dispatch(setModeValue({ mode, selectmenulist, commentFlag }));
  },
  onDeleteComment: ({ selectmenulist }) => {
    dispatch(deleteValue({ selectmenulist, commentFlag }));
  },
  actions: bindActionCreators(judCmtStcActions, dispatch),

});

export default connect(mapStateToProps, mapDispatchToProps)(MenFoodCommentGuideBody2);
