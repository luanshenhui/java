import React from 'react';
import { Link, withRouter } from 'react-router-dom';
import { Field } from 'redux-form';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import PropTypes from 'prop-types';
import DropDown from '../../components/control/dropdown/DropDown';
import { FieldGroup, FieldSet, FieldValue } from '../../components/Field';
import SectionBar from '../../components/SectionBar';
import Button from '../../components/control/Button';
import AdviceCommentGuide from '../../containers/common/AdviceCommentGuide';
import { setSelectedEntryRecogLevelItem } from '../../modules/judgement/interviewModule';
import { actions as judCmtStcActions } from '../../modules/preference/judCmtStcModule';

const judClassCd = 50;

// 描画処理
const EntryRecogLevelHeader = ({ open, actions, itemName, items, initialSelected, setListItem, formValues }) => (
  <div>
    <AdviceCommentGuide
      open={open}
      onSelect={(selected) => setListItem(selected, formValues)
      }
    />
    <SectionBar title="生活指導コメント" />
    <FieldGroup>
      <FieldSet>
        <FieldValue>認識レベル:</FieldValue>
        <Field name="recoglevel" component={DropDown} items={items} />
        <div style={{ width: '20px' }} />
        <FieldValue>前回認識レベル:</FieldValue>
        <div> { itemName }</div>
        <div style={{ width: '150px' }} />
        <a href="#" onClick={() => actions.openAdviceCommentGuideRequest({ judClassCd, initialSelected })} >コメントの選択</a>
        <div style={{ width: '20px' }} />
        <Button type="submit" value="保存" />
        <div style={{ width: '20px' }} />
        <Link to="/preference/maintenance/interviewtop">虚血性心疾患画面へ</Link>
      </FieldSet>
    </FieldGroup>
  </div>
);

// propTypesの定義
EntryRecogLevelHeader.propTypes = {
  itemName: PropTypes.shape(),
  items: PropTypes.shape(),
  open: PropTypes.bool.isRequired,
  actions: PropTypes.shape().isRequired,
  initialSelected: PropTypes.arrayOf(PropTypes.shape()),
  formValues: PropTypes.arrayOf(PropTypes.shape()),
  setListItem: PropTypes.func.isRequired,
};

EntryRecogLevelHeader.defaultProps = {
  itemName: undefined,
  items: undefined,
  formValues: undefined,
  initialSelected: undefined,
};

const mapStateToProps = (state) => ({
  open: state.app.preference.judCmtStc.adviceCommentGuide.open,
});

const mapDispatchToProps = (dispatch) => ({
  setListItem: (params, formValues) => {
    const conditions = {};
    dispatch(setSelectedEntryRecogLevelItem({ ...conditions, params, formValues }));
  },
  actions: bindActionCreators(judCmtStcActions, dispatch),
});
export default withRouter(connect(mapStateToProps, mapDispatchToProps)(EntryRecogLevelHeader));

